Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620631680CB
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgBUOvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 09:51:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42654 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUOvg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 09:51:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id e8so935814plt.9
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 06:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XkW32rFdoI9LQIwoNQDAjjZLdSB2QjnaqfUyN+aGZAU=;
        b=MJmfm0/Wm48ca6ajDn7eVA0BgRNn/4UGbuLc2TQJADaE53NdH3tx0Dj9DraeWvUNFr
         d3icqORcL/hjhdeXzl0S1lhfgTBipyplj3KdvHgkXgkviwd6nvE2kEviKTxJ7I4gaG6C
         dzpGSYSq47ztFBDH/FayUs/XDuYE0QZtAJw28cNxcJ1btns6nD4oYrLz6DVofJLVU3bP
         LYVGyES1H+A5Mlzp3c62E5g8ad2BnncmDon2B2kgTjcUGWOzO02R5Moo2XVDJ8g6OqD3
         zXMLeIgoFy2W+cGOJdBl+I5zfQZcRGjf/QzFIO+lQuySVRImKH96FAPg56pSE/OuskNo
         P/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkW32rFdoI9LQIwoNQDAjjZLdSB2QjnaqfUyN+aGZAU=;
        b=Th3ta/vr7zl/naXJKaEGHWIVUbc8diO+n/lSTomeMcg21WWVAZF8PXEsULqcZHBcdJ
         AUy20cImeXhpmOQMdsW4DTaySA/fGGVOcmIlgrxYicaHXhrOOiJHge7iIZmZQf8eljep
         AtMvJ1RIUMQW9H5YZ1dlrwkmjWwisgrVJbNrM/Vu8uJqcf9/gLVemziMgo+Wo5G9yHSU
         kVmwUTUtoJBCVd5TzJBcyy6gX/YvlgEgYZOWvYF4saAsU/LCs+3H7GQbHQD53WM80d/j
         rB60MtUcRbcSrjXxZmNHQee15S67Wu+rCzCs45u3CzEXE9VpY01zdUCxmdx2zViwPyb5
         3dCQ==
X-Gm-Message-State: APjAAAXjYAU+WzmgFVpjh7vcJArrvbOpdw0LwzbMEWLXGnj0PaB+5Oag
        Z66xdtI6OS2JGhuX3KFbZYz5Kw==
X-Google-Smtp-Source: APXvYqwLFAuhxCcJAwPqzCaIQKcf54AX7bqA0KI4w7YwsFXjk/n+lCgg9ovUN1zHPRwWbPELjrvSpA==
X-Received: by 2002:a17:90a:8001:: with SMTP id b1mr3514371pjn.39.1582296694728;
        Fri, 21 Feb 2020 06:51:34 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:fdca:2b3c:ac97:51da? ([2605:e000:100e:8c61:fdca:2b3c:ac97:51da])
        by smtp.gmail.com with ESMTPSA id fz21sm2995092pjb.15.2020.02.21.06.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:51:34 -0800 (PST)
Subject: Re: Crash on using the poll ring
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <CAD-J=zbKXuF1HCd5yG0oNaizNWZTD3248Oii7xoofQ--EqO3dw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97074e5b-896e-6bd5-3c6e-bfa38bf522c4@kernel.dk>
Date:   Fri, 21 Feb 2020 06:51:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbKXuF1HCd5yG0oNaizNWZTD3248Oii7xoofQ--EqO3dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 6:17 AM, Glauber Costa wrote:
> Hi
> 
> Today I found a crash when adding code for the poll ring to my implementation.
> Kernel is 2b58a38ef46e91edd68eec58bdb817c42474cad6
> 
> Here's how to reproduce:
> 
> code at
> https://github.com/glommer/seastar.git branch poll-ring
> 
> 1. same as previous steps to configure seastar, but compile with:
> ninja -C build/release apps/io_tester/io_tester
> 
> 2. Download the yaml file attached
> 
> 3. Run with:
> 
> ./build/release/apps/io_tester/io_tester --conf ~/test.yaml --duration
> 15 --directory /var/disk1  --reactor-backend=uring --smp 1
> 
> (directory must be on xfs because we do c++ but we're not savages)

This is due to killing the dummy callback function on the task work.
I'll play with this a bit and see how we can fix it.

-- 
Jens Axboe

