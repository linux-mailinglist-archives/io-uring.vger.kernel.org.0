Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F36159C3D
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 23:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBKWcj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 17:32:39 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57975 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBKWci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 17:32:38 -0500
X-Originating-IP: 92.243.9.8
Received: from localhost (joshtriplett.org [92.243.9.8])
        (Authenticated sender: josh@joshtriplett.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 8206040002;
        Tue, 11 Feb 2020 22:32:36 +0000 (UTC)
Date:   Tue, 11 Feb 2020 14:32:35 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: RFC: userspace-allocated file descriptors for "fixed files" for open?
Message-ID: <20200211223235.GA25104@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The X Window System had a solution that allowed an asynchronous batch of
"create thing, do stuff with thing": X allowed the client to allocate
XIDs, and just had an operation for "give me an additional batch of XIDs
I can allocate".

Could we do the same thing in io_uring, as a variant of the "fixed file"
concept? Suppose that we add a call to preallocate a large contiguous
range of file descriptors, and ensure that the kernel never allocates
those file descriptors for an application.  We could then allow
userspace to *tell* the kernel to use a specific preallocated file
descriptor in that range when it does an OPENAT or OPENAT2 operation,
and then go on to use that file descriptor in a subsequent
read/write/close/etc operation.

(If the open operation returns an error, it won't have allocated that
file descriptor, so subsequent operations will just fail quickly with
EBADF, which seems fine.)

This seems simple for userspace to deal with, and would work for many
use cases.

Thoughts?

- Josh Triplett
