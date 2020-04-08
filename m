Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD851A2513
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgDHPZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:25:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39221 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgDHPZQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:25:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id g32so3459403pgb.6
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BI0LpeSIMVx070wajzrdqztQzFkxuBgOVuQTyvit/aU=;
        b=ROEbf1uF9mKFhcznEhAziWgwQDMcCA1MDZLmR5CyEvTptLvFStDG3Dz79YW3V++QI0
         7Wu9qJWIdV5GvujcMsvFii47uyuSIAnTyq6t5niZzzpyaT9E7arlCwasnsQ3JznIXAx/
         xxKPHkwNOjZvZfEyEubAgUVapid1YSkz2sxJmhFp4lTqqCeWRanKhRfHa/7tt2gShc3e
         j+gyhMGZPvSOjibyyW8LBvPN+MG8bQe1nI4zQhgGhYnfKItHcxupD8zn9IZiZL8ccHvI
         jzVvi+nlKmJLMNR6bEuYUk46Rn+EBB9mqG2UjPAklTbwUvCfOUoV1W67EPFa0GoX7xIS
         tOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BI0LpeSIMVx070wajzrdqztQzFkxuBgOVuQTyvit/aU=;
        b=skOLDFkAqY4ciyRXoxK9N15ri2+/TAuBFRZIAbdsz+2GBu0kxnDfF64rkdey7c+lR6
         vsB7/BswZ3rHyMG9k7zGiIezM1qTq1rYb2Iwh0WOgc9Pu2yHDN9G5lnKY9f9zyvWWkS6
         kK26oI/59cP9HAOsripeNCO8wtw4m0/yAN54LW2cJo3g5q64/n386B790cKI5SF43Kdd
         Mv2iMh4GvdgyFrdWG8e5IcSOM7fYQBni38nII/7FaiIbGGCkhSjmZQ/iTL4kgMEXa+SY
         bwNlOujrf9c/zvNf3EHMiP+xJcCynLl8HKVgPZvh2Uhwqt+5xacEobZljxoF2Xaqr7BF
         6fVA==
X-Gm-Message-State: AGi0PuaJgihd7OP0K4mBf7io3tX80DOvLA6TLPnLtcpLriDdilYAogv+
        7hyPE8Z8Fc/zmh+V+z+w+NMg0G7loRP7OQ==
X-Google-Smtp-Source: APiQypKn2hMVoUID6fvFKbRhWhzUoVySjdqm+QpKh23I9Cu+hrQnSHDu9pPOa2MBcVQCQlu1RnfDRA==
X-Received: by 2002:a63:6d87:: with SMTP id i129mr7478865pgc.54.1586359193422;
        Wed, 08 Apr 2020 08:19:53 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4466:6b33:f85b:7770? ([2605:e000:100e:8c61:4466:6b33:f85b:7770])
        by smtp.gmail.com with ESMTPSA id z8sm4522939pju.33.2020.04.08.08.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:19:52 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
Date:   Wed, 8 Apr 2020 08:19:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> Hi,
> 
> io_uring's openat seems to produce FDs that are incompatible with
> large files (>2GB). If a file (smaller than 2GB) is opened using
> io_uring's openat then writes -- both using io_uring and just sync
> pwrite() -- past that threshold fail with EFBIG. If such a file is
> opened with sync openat, then both io_uring's writes and sync writes
> succeed. And if the file is larger than 2GB then io_uring's openat
> fails right away, while the sync one works.
> 
> Kernel versions: 5.6.0-rc2, 5.6.0.
> 
> A couple of reproducers attached, one demos successful open with
> failed writes afterwards, and another failing open (in comparison with
> sync  calls).
> 
> The output of the former one for example:
> 
> *** sync openat
> openat succeeded
> sync write at offset 0
> write succeeded
> sync write at offset 4294967296
> write succeeded
> 
> *** sync openat
> openat succeeded
> io_uring write at offset 0
> write succeeded
> io_uring write at offset 4294967296
> write succeeded
> 
> *** io_uring openat
> openat succeeded
> sync write at offset 0
> write succeeded
> sync write at offset 4294967296
> write failed: File too large
> 
> *** io_uring openat
> openat succeeded
> io_uring write at offset 0
> write succeeded
> io_uring write at offset 4294967296
> write failed: File too large

Can you try with this one? Seems like only openat2 gets it set,
not openat...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79bd22289d73..63eb7efe10f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2957,6 +2957,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->open.how.mode = READ_ONCE(sqe->len);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.how.flags = READ_ONCE(sqe->open_flags);
+	if (force_o_largefile())
+		req->open.how.flags |= O_LARGEFILE;
 
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {

-- 
Jens Axboe

