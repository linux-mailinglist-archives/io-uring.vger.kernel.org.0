Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B73434E64D
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 13:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhC3LXJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 07:23:09 -0400
Received: from hmm.wantstofly.org ([213.239.204.108]:40452 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhC3LWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 07:22:55 -0400
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id AED707F4C0; Tue, 30 Mar 2021 14:22:54 +0300 (EEST)
Date:   Tue, 30 Mar 2021 14:22:54 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] IORING_OP_GETDENTS: add opcode, prep function,
 test, man page section
Message-ID: <YGMKDtEr85h5fJXH@wantstofly.org>
References: <20210218122842.GD334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218122842.GD334506@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 18, 2021 at 02:28:42PM +0200, Lennert Buytenhek wrote:

> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> ---

I'll shortly send a v2 of this that will:

- update the man page to specify that the file offset is updated
  unconditionally by IORING_OP_GETDENTS;

- update the man pages to indicate that IORING_FEAT_RW_CUR_POS
  also applies to IORING_OP_GETDENTS;

- update the getdents test to verify that offset == -1 reads from
  the current directory offset.
