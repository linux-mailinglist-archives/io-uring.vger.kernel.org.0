Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DC7309B38
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 10:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhAaJTu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 04:19:50 -0500
Received: from rydia.net ([173.255.253.96]:39839 "EHLO mail.rydia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhAaJTZ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 31 Jan 2021 04:19:25 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2021 04:19:24 EST
Received: from dry.lan (104-9-122-4.lightspeed.sntcca.sbcglobal.net [104.9.122.4])
        by mail.rydia.net (Postfix) with ESMTPA id D01B44A69
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 01:10:31 -0800 (PST)
Date:   Sun, 31 Jan 2021 01:10:27 -0800 (PST)
From:   dormando <dormando@rydia.net>
To:     io-uring <io-uring@vger.kernel.org>
Subject: tcp short writes / write ordering / etc
Message-ID: <855d3bc1-f694-e42e-283e-f8ee8f9c8e6e@rydia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey,

I'm trying to puzzle out an architecture on top of io_uring for a tcp
proxy I'm working on. I have a high level question, then I'll explain what
I'm doing for context:

- How (is?) order maintained for write()'s to the same FD from different
SQE's to a network socket? ie; I get request A and queue a write(), later
request B comes in and gets queued, A finishes short. There was no chance
to IOSQE_LINK A to B. Does B cancel? This makes sense for disk IO but I
can't wrap my head around it for network sockets.

The setup:

- N per-core worker threads. Each thread handles X client sockets.
- Y backend sockets in a global shared pool. These point to storage
servers (or other proxyes/anything).

- client sockets wake up with requests for an arbitrary number of keys (1
to 100 or so).
  - each key is mapped to a backend (like keyhash % Y).
  - new requests are dispatched for each key to each backend socket.
  - the results are put back into order and returned to the client.

The workers are designed such that they should not have to wait for a
large request set before processing the next ready client socket. ie;
thread N1 gets a request for 100 keys; it queues that work off, and then
starts on a request for a single key. it picks up the results of the
original request later and returns it. Else we get poor long tail latency.

I've been working out a test program to mock this new backend. I have mock
worker threads that submit batches of work from fake connections, and then
have libevent or io_uring handle things.

In libevent/epoll mode:
 - workers can directly call write() to backend sockets while holding a
lock around a descriptive structure. this ensures order.
 - OR workers submit stacks to one or more threads which the backends
sockets are striped across. These threads lock and write(). this mode
helps with latency pileup.
 - a dedicated thread sits in epoll_wait() on EPOLLIN for each backend
socket. This avoids repeated calls to epoll_add()/mod/etc. As responses
are parsed, completed sets of requests are shipped back to the worker
threads.

In uring mode:
 - workers should submit to a single (or few) threads which have a private
ring. sqe's are stacked and submit()'ed in a batch. Ideally saving all of
the overhead of write()'ing to a bunch of sockets. (not working yet)
 - a dedicated thread with its own ring is sitting on recv() for each
backend socket. It handles the same as epoll mode, except after each read
I have to re-submit a new SQE for the next read.

(I have everything sharing the same WQ, for what it's worth)

I'm trying to figure out uring mode's single submission thread, but
figuring out the IO ordering issues is blanking my mind. Requests can come
in interleaved as the backends are shared, and waiting for a batch to
complete before submitting the next one defeats the purpose (I think).

What would be super nice but I'm pretty sure is impossible:

- M (possibly 1) thread(s) sitting on recv() in its own ring
- N client handling worker threads with independent rings on the same WQ
 - SQE's with writes to the same backend FD are serialized by a magical
unicorn.

Then:
- worker with a request for 100 keys makes and submits the SQE's itself,
  then moves on to the next client connection.
- recv() thread gathers responses and signals worker when the batch is
complete.

If I can avoid issues with short/colliding writes I can still make this
work as my protocol can allow for out of order responses, but it's not the
default mode so I need both to work anyway.

Apologies if this isn't clear or was answered recently; I did try to read
archives/code/etc.

Thanks,
-Dormando
