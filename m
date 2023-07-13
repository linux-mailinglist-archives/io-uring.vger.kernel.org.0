Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84C7517B9
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 06:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjGMEvI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 00:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbjGMEvG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 00:51:06 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971591FFC;
        Wed, 12 Jul 2023 21:51:05 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id CF24DC01E; Thu, 13 Jul 2023 06:51:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689223863; bh=U54Q0Bm+VD70kq6r3FtxS6F0p7UiOHf+MfrdfrTU7rI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=zNl0yXDsyUqV9fEYunLi172pmnL5HSM48jOYkWRMNT6qqFfa+PNGnZThD44hoBt2h
         zTSVf3Ae9SBmvS3ZPh3INpELjYG2DOC9Pe9X4/EVRziCxfUFhTtoReXAnXVhYdlK1M
         lrguuyneQJF3JLHW4kBSpYaCZfHcqUqaHRo1UxDHHZtvEiCOJwhvDu4XjAIQd9G17P
         DXN+FM+Xpf62EzQ1zf5SUIDC2IEvEXbR2TdiMkUYBi5TMMaxZM8aK+cHyEbYOpn8TU
         zje6luB7D6+ROxM6/txrKMRkl06cM8ATlZ2JPe38vcpAuNPTKXRn9Y0oYu03EtCpck
         fRCI+6+60XkdQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 8E52DC009;
        Thu, 13 Jul 2023 06:50:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689223863; bh=U54Q0Bm+VD70kq6r3FtxS6F0p7UiOHf+MfrdfrTU7rI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=zNl0yXDsyUqV9fEYunLi172pmnL5HSM48jOYkWRMNT6qqFfa+PNGnZThD44hoBt2h
         zTSVf3Ae9SBmvS3ZPh3INpELjYG2DOC9Pe9X4/EVRziCxfUFhTtoReXAnXVhYdlK1M
         lrguuyneQJF3JLHW4kBSpYaCZfHcqUqaHRo1UxDHHZtvEiCOJwhvDu4XjAIQd9G17P
         DXN+FM+Xpf62EzQ1zf5SUIDC2IEvEXbR2TdiMkUYBi5TMMaxZM8aK+cHyEbYOpn8TU
         zje6luB7D6+ROxM6/txrKMRkl06cM8ATlZ2JPe38vcpAuNPTKXRn9Y0oYu03EtCpck
         fRCI+6+60XkdQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 2b9f6bf3;
        Thu, 13 Jul 2023 04:50:56 +0000 (UTC)
Date:   Thu, 13 Jul 2023 13:50:41 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Message-ID: <ZK-CoRT5J8MQ-hc5@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <077f4874-015b-a534-4a29-de877b735e38@linux.dev>
 <bb89b1f8-dfdc-8912-b874-d552bc4b5f9d@linux.dev>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu wrote on Thu, Jul 13, 2023 at 12:05:00PM +0800:
> Yes, like Al pointed out, getdents with an offset is not the right way to do
> it,
> 
> So a way to do seek is a must. But like what I said in the cover-letter, I
> do think the right thing is to
> 
> import lseek/llseek to io_uring, not increment the complex of getdents.

Ok, sorry I hadn't read the cover letter properly


Hao Xu wrote on Thu, Jul 13, 2023 at 12:40:05PM +0800:
> > Ah, I misunderstood your question, sorry. The thing is f_count is
> > init-ed to be 1,
> > 
> > and normal uring requests do fdget first, so I think it's ok for normal
> > requests.
> > 
> > What Christian points out is issue with fixed file, that is indeed a
> > problem I think.
> 
> After re-think of it, I think there is no race in fixed file case as
> well, because the f_count is always >1

Let's remove the if > 1 check then

-- 
Dominique Martinet | Asmadeus
