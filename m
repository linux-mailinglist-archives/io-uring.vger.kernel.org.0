Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1791169C94
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 04:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBXDRv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 22:17:51 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:36447 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgBXDRv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 22:17:51 -0500
Received: by mail-pj1-f53.google.com with SMTP id gv17so3532657pjb.1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 19:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0C+u105u7vUj3rwXUsU7xoOdeOHDnu/Rjr2zpyE8PCI=;
        b=bgDVuwv3vSPuGFXtXW9NZOw8Nmmtc1Jlhbu5Mx3P1L1OPGGm6MaTVlA+VWQXWZYyqQ
         Gwx92CZItc8a1KQsdkIL6f11TPJwcB0/OsDsrIp/9dIrimlmydvPDyWVpMJJSQEz+a+1
         Ewy5umg2KIk6x4b3KmSqVixpayhs+XI3YJ3lzAJLvIegketc4tZ3QuAGwyr6mPqwRlx9
         2vUgZwM73c9EKL6hH+6PyQ1ZxfNnykxMGEUd9MvQzmrdUfQhcgGt4cTBifpbRonkWhK3
         iIkldkkhCL+J6kGbrUsCBMAJ/fBb4QkWjAVBRGyo0gQQVuxXV7enBtFMP/gKs3afQM02
         EN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0C+u105u7vUj3rwXUsU7xoOdeOHDnu/Rjr2zpyE8PCI=;
        b=cxNUcm9jOnfsmPqWS116HfqUcZQSrRnNMhQ8iYCrQ5fCsCxn739HM4ailDTdYNZcfZ
         v+PT/1ZaO2abIIY1cdZKXReBbrlRMHrCFfauzvZyKBHmp0LYKvjuPOXPxya5SqqJ2UO0
         fNzLXo7hy23tdu9YzoO60WkVYI4Kpnj9jj0d+AKwZ3MtlTS/7SEmW0FyCvm6dKUQ/Fve
         DXZDf/s1LR0lymZdUaxzHZCF9cGfHULakvCcAKgu8o4qiwUGaTvFiCTXOQ6ukPw13Mlx
         SrqdUrfn+DOAolEJLs7ftVwCchEeYNr9VJugNoc65ZEzhDkLQjyEGXDD7acFPBecH8Xx
         ek9w==
X-Gm-Message-State: APjAAAVhwOJZfsEp0scNLibJ/Mxg9uaNTOBhBjr33G4htVCx+m31SVNU
        iH0n39BjWwpmBVcgB7KG30Epba5KhMk=
X-Google-Smtp-Source: APXvYqyxXykQPICVq8z4E6HsBmUSxglZsU0wi4hkJDTEVp0TxUGrkPTesxbseVGgH6c2AGftyCMm5g==
X-Received: by 2002:a17:90a:26ec:: with SMTP id m99mr17846284pje.130.1582514268575;
        Sun, 23 Feb 2020 19:17:48 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c19sm10624520pfc.144.2020.02.23.19.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 19:17:47 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
Date:   Sun, 23 Feb 2020 20:17:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 6:07 PM, Andres Freund wrote:
> Hi,
> 
> There's currently two places that know to call io_*_prep() for
> sqes. io_req_defer_prep() and io_issue_sqe(). E.g. for READV there's:
> 
> static int io_req_defer_prep(struct io_kiocb *req,
> 			     const struct io_uring_sqe *sqe)
> ...
> 	case IORING_OP_READV:
> 	case IORING_OP_READ_FIXED:
> 	case IORING_OP_READ:
> 		ret = io_read_prep(req, sqe, true);
> 		break;
> 
> and
> 
> static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> 			struct io_kiocb **nxt, bool force_nonblock)
> {
> ...
> 	case IORING_OP_READV:
> 	case IORING_OP_READ_FIXED:
> 	case IORING_OP_READ:
> 		if (sqe) {
> 			ret = io_read_prep(req, sqe, force_nonblock);
> 			if (ret < 0)
> 				break;
> 		}
> 		ret = io_read(req, nxt, force_nonblock);
> 		break;
> 
> that seems a bit unnecessary. How about breaking that out into a
> separate function?  I can write up a patch, just didn't want to do so if
> there's a reason for the current split.
> 
> 
> Alternatively it'd could all be just be dispatches via io_op_defs, but
> that'd be a bigger change with potential performance implications. And
> it'd benefit from prior deduplication anyway.

The reason for the split is that if we defer a request, it has to be
prepared up front. If the request has been deferred, then the
io_issue_sqe() invocation has sqe == NULL. Hence we only run the prep
handler once, and read the sqe just once.

This could of course be compacted with some indirect function calls, but
I didn't want to pay the overhead of doing so... The downside is that
the code is a bit bigger.

-- 
Jens Axboe

