Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4B434AA6
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 14:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJTMCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 08:02:55 -0400
Received: from out0.migadu.com ([94.23.1.103]:23276 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhJTMCz (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 20 Oct 2021 08:02:55 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1634731238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSgAD5696lnv6+xU56lY6UEyoxuHpDcZr4RgeiJr0o8=;
        b=r47fRdpGzKw4qFUIZPSUuM3ckF0OhmNvAPKujywFao2ZQx4bthVXBmYYT5JnEsrk+P/yZi
        DL1KVCclFvCF2OJ1LOGZOo6BrYXlvuuPMTcC66/Ifup3p9RWY1i92dduFA8gXORoUrwHa7
        EP9VOamtJ9kKJpVF54295ZwOI+jQCEC0bwwnsIcLdCgB4RVzD4o6pIgrTU594d3m/Zy1+c
        +k61DW/8LPhVsXzGzo3wA9lLhktBonoG3qE5/XA4rJKYTFWZaGQjI98L6hbij+pCBFq+iU
        OpCfi7X6WJWWpbuNncjqzWqA+fQmU8Ul/U5OA753Kk/MmkQqnjrzthLYH0yN6g==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 20 Oct 2021 14:00:38 +0200
Message-Id: <CF47UZE6WXQ6.1MZDZ8OPGM0TW@taiga>
Subject: Re: Polling on an io_uring file descriptor
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
 <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
 <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
In-Reply-To: <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed Oct 20, 2021 at 1:58 PM CEST, Pavel Begunkov wrote:
> > One issue which remains is that attempting to use REGISTER_FILES on
> > io_uring A with io_uring B's file descriptor returns EBADF. I saw a
> > comment in the kernel source explaining this, but it's a bit contrived
> > and the error case is not documented.
>
> Surely should be updated if not mentioned

That, or the constraint removed? The reasoning is a bit obscure and I
suspect that this case could be made possible.
