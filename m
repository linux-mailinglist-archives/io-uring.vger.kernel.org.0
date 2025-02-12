Return-Path: <io-uring+bounces-6387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 218B7A331C2
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD37A167C9C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F319202F64;
	Wed, 12 Feb 2025 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EQGNIl1P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750141FF1DF
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739397258; cv=none; b=BNDqP54CjpqUjrqXlfN9uW5Hr6Qyj1KSKcBtbq8WBIEhoPDWa+CsJo/ZmZDHrPYAyLgziL8by3JD2R5x+jx/5Q7SYtPji4Hvf8KB1sPiSyoxm4SvVS7NTGJVtr62fqogjTCKzYZb4oUXznnIzsbaVxV+hLpcIMC0U7J2JGDe4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739397258; c=relaxed/simple;
	bh=ge4KnJE9iF/Hb51/g1qMq1pqhpakVBP2W0kIbMPxNuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEHoBXciVqgHf9vW8Xh6b2qFlvUgWcIW+AKXKLMka11Ph7MluhWCJTRKxV3bl4lV9OEFwYz2ieb1unB6CV7W7g+IO7jpX5gNghr8I7Cq1fN6uBu5jyJ1Vk3g+p1Vyn+VGiAPKPFH2nx4w0m4MQhIMgDyV03nMTXokd/LqkXd3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EQGNIl1P; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fc0ab102e2so57078a91.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 13:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739397256; x=1740002056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ge4KnJE9iF/Hb51/g1qMq1pqhpakVBP2W0kIbMPxNuI=;
        b=EQGNIl1P++FY7kb7pZTgZbLlrejX0W20GP/taow66+5eneahHx/GQKFOHo/txN6QS3
         Po9uOP6VWZmwxKwxrLWBY4mb7EE8KsAmwCzdaZdHlkKF4/MkTyK6uEaHvDGBfrAHzkej
         xwN1N4OPicUNywvCetOAZRFIXytNA3MkSxNnuoxqBw7IhhTnb0Olm/ywkN3zbIvidOyh
         ym+jCHqN0IVfGk4qMykBdPs+3BTwFhI5Q2yMGTOOrokXEpZTYhv0U8WiBPdoyZ2kmnkq
         t8QkDPPzm++gFT77TWKNCC6EwBDZDRJ5HwJv4oKx1buzEOPCmJaqqWeuZnaCVdtfEIGE
         Y9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739397256; x=1740002056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ge4KnJE9iF/Hb51/g1qMq1pqhpakVBP2W0kIbMPxNuI=;
        b=N4aUY0mIfcRpTXm1co+IW5AIIi/47Qm4a9k1gULUdTRcuKaGXOGnZ+HT19DhcY8jLW
         CnTom4axf8YK0ldFSn2ROgFC5tmHTeJIxNyj9jt5E29AO0cQjy3jK1pVUdKjo/ZiPCmJ
         AIR+BakRjTtaDu9GPMpBcM/QmjIJrp66bdh9kPJRYVrow3gTQPk0DoXhkfWELJSDDlsk
         LNKFrTp9KthjJQ5A7EW7YNnFeh+xVfa8L7aGvSOMxXEaS4lk1fR+qqEfTNgsYMgG2gN0
         FFNgzlGSswO1lynRGMjv958CWozPeUGTr78hL3Mvhd/OwYrKEh1v6HOSJivvqXJHypB5
         n/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv/mDBG+bWVGkRQa2CON4O/16CRyrg5Z6pzqg8esnNZNpTHBmJFwGE/QzXCIRkmOyNYwISMX5mdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwHL/p2QtmWn0pvw1H4YA05mAhFszBe7oBO/98LcL7eRIKqtgG
	ip3XYspyVmCrowEza9do5Hnr66YRTz2NSTeCMmrAAA0JX+PQfHuBGh3E4o1NLPoY76MpyM7Gu3n
	7dPxse5JedWj4XaWxEABw5Bh2/agLn6zuZiRufg==
X-Gm-Gg: ASbGncvxtnwL9IuhAInDYU0zVlf44S2l7/p7dnLnzT5fWL91YBjPM4oqv1czckx6HC/
	n8NzDk/YbxHmD5M17wavm71lTNA2Ij491zkhSZR0wHelk2OjQc5p73+P7Sp5QXL0/do/71s8=
X-Google-Smtp-Source: AGHT+IFMPPrqn7iYY9wkKzTPFCyHNXNPaj9gPzkjTZXdJ0obkphwjRRUI8sA0P0Jhavsgh95Xj1lYdfCmXfewd6bbNM=
X-Received: by 2002:a17:90b:4d10:b0:2ee:6563:20b5 with SMTP id
 98e67ed59e1d1-2fbf5ae2309mr2747947a91.0.1739397255602; Wed, 12 Feb 2025
 13:54:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212204546.3751645-1-csander@purestorage.com> <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
In-Reply-To: <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
From: Caleb Sander <csander@purestorage.com>
Date: Wed, 12 Feb 2025 13:54:03 -0800
X-Gm-Features: AWEUYZnzoun66gvLZAA01wN8hsHo0qQJKTPwxuyLywzkWLXEd9UHZi-LzapCfiE
Message-ID: <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Riley Thomasson <riley@purestorage.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 12:55=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
> > In our application issuing NVMe passthru commands, we have observed
> > nvme_uring_cmd fields being corrupted between when userspace initialize=
s
> > the io_uring SQE and when nvme_uring_cmd_io() processes it.
> >
> > We hypothesized that the uring_cmd's were executing asynchronously afte=
r
> > the io_uring_enter() syscall returned, yet were still reading the SQE i=
n
> > the userspace-mapped SQ. Since io_uring_enter() had already incremented
> > the SQ head index, userspace reused the SQ slot for a new SQE once the
> > SQ wrapped around to it.
> >
> > We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
> > index in userspace upon return from io_uring_enter(). By overwriting th=
e
> > nvme_uring_cmd nsid field with a known garbage value, we were able to
> > trigger the err message in nvme_validate_passthru_nsid(), which logged
> > the garbage nsid value.
> >
> > The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
> > SQE copying until it's needed"). With this commit reverted, the poisone=
d
> > values in the SQEs are no longer seen by nvme_uring_cmd_io().
> >
> > Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
> > to async_data at prep time. The commit moved this memcpy() to 2 cases
> > when the request goes async:
> > - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
> > - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
> >
> > This patch set fixes a bug in the EAGAIN case where the uring_cmd's sqe
> > pointer is not updated to point to async_data after the memcpy(),
> > as it correctly is in the REQ_F_FORCE_ASYNC case.
> >
> > However, uring_cmd's can be issued async in other cases not enumerated
> > by 5eff57fa9f3a, also leading to SQE corruption. These include requests
> > besides the first in a linked chain, which are only issued once prior
> > requests complete. Requests waiting for a drain to complete would also
> > be initially issued async.
> >
> > While it's probably possible for io_uring_cmd_prep_setup() to check for
> > each of these cases and avoid deferring the SQE memcpy(), we feel it
> > might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
> > As discussed recently in regard to the ublk zero-copy patches[1], new
> > async paths added in the future could break these delicate assumptions.
>
> I don't think it's particularly delicate - did you manage to catch the
> case queueing a request for async execution where the sqe wasn't already
> copied? I did take a quick look after our out-of-band conversation, and
> the only missing bit I immediately spotted is using SQPOLL. But I don't
> think you're using that, right? And in any case, lifetime of SQEs with
> SQPOLL is the duration of the request anyway, so should not pose any
> risk of overwriting SQEs. But I do think the code should copy for that
> case too, just to avoid it being a harder-to-use thing than it should
> be.

Yes, even with the EAGAIN case fixed, nvme_validate_passthru_nsid() is
still catching the poisoned nsids. However, the log lines now come
from the application thread rather than the iou-wrk thread.
Indeed, we are not using SQPOLL. But we are using IOSQE_SQE_GROUP from
Ming's SQE group patch set[1]. Like IOSQE_IO_LINK, subsequent
operations in a group are issued only once the first completes. The
first operation in the group is a UBLK_IO_PROVIDE_IO_BUF from Ming's
other patch set[2], which should complete synchronously. The
completion should be processed in __io_submit_flush_completions() ->
io_free_batch_list() and queue the remaining grouped operations to be
issued in task work. And all the pending task work should be processed
during io_uring_enter()'s return to userspace.
But some NVMe passthru operations must be going async because they are
observing the poisoned values the application thread writes into the
io_uring SQEs after io_uring_enter() returns. We don't yet have an
explanation for how they end up being issued async; ftrace shows that
in the typical case, all the NVMe passthru operations in the group are
issued during task work before io_uring_enter() returns to userspace.
Perhaps a pending signal could short-circuit the task work processing?

Best,
Caleb

[1]: https://lore.kernel.org/io-uring/20240511001214.173711-2-ming.lei@redh=
at.com/T/
[2]: https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@r=
edhat.com/T/

>
> The two patches here look good, I'll go ahead with those. That'll give
> us a bit of time to figure out where this missing copy is.
>
> --
> Jens Axboe

