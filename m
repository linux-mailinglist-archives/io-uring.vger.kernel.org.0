Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03351179881
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgCDTC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:02:26 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57355 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgCDTC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:02:26 -0500
X-Originating-IP: 92.243.9.8
Received: from localhost (joshtriplett.org [92.243.9.8])
        (Authenticated sender: josh@joshtriplett.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id F31211C0009;
        Wed,  4 Mar 2020 19:02:23 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:02:23 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
Subject: Re: [PATCH 6/6] io_uring: allow specific fd for IORING_OP_ACCEPT
Message-ID: <20200304190223.GA16251@localhost>
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304180016.28212-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304180016.28212-7-axboe@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 04, 2020 at 11:00:16AM -0700, Jens Axboe wrote:
> sqe->len can be set to a specific fd we want to use for accept4(), so
> it uses that one instead of just assigning a free unused one.
[...]
> +	accept->open_fd = READ_ONCE(sqe->len);
> +	if (!accept->open_fd)
> +		accept->open_fd = -1;

0 is a valid file descriptor. I realize that it seems unlikely, but I
went to a fair bit of trouble in my patch series to ensure that
userspace could use any valid file descriptor openat2, without a corner
case like "you can't open as file descriptor 0", even though it would
have been more convenient to just say "if you pass a non-zero fd in
open_how". Please consider accepting a flag to determine the validity of
open_fd.

- Josh Triplett
