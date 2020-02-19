Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31216384A
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 01:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgBSANI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 19:13:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40765 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBSANH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 19:13:07 -0500
Received: by mail-pg1-f196.google.com with SMTP id z7so11772940pgk.7
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 16:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=h9xR+esW8+adxP0k+n9/ZSkR3WhTOXw6mobByO5RQs4=;
        b=Cu8vWonlPr09IL8aoOenoNCqEeVsrENWfmeGZA2G1lLJuvs4f9ZzGIbNvnnIWE/F7v
         VArETZ9sMiKFDOmfRMutiU40ASz+AfMaI2qKr4+VQiAQ/h3v0a0IvQQ2sgXSGb7Y0CwF
         Gc7m3UwrBgT1i838ytRfR21N7aPSY2BWG8M2IpTshD27Bil4EBw7wWWjM6YzVITHT71R
         xLa0KLY5tgLhrd/WdAznHL+fSOUfd1XueoQh/IYvdTrTW6menZxfPnKDhXHDYF6TWINN
         axRg6NiQN2BM+0EXuekw7cRlou/qF58QVf5nONKGB/YGWJRIWnHy/F34WxJu/Ld6CLaC
         IvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9xR+esW8+adxP0k+n9/ZSkR3WhTOXw6mobByO5RQs4=;
        b=Vi3VC7DXHdODIaFjpfZYu5BguTU5e4UGBd2C7ctiLbgnKKkBKODR6DhFQ8ZS4+2NGd
         lGlSemsvpEklrjQ2E6GwOO9wtzK1e5x6HT/OeHrP76EtpCbzQzzy/GuZ7qWd9Aq/5UlO
         Gbap3fJZ9ilf2B7A72y0EZZbTzOO7S4gjnN4kTDZB7IAKKZZ7bZqofCvtmhQ/bsrSKuJ
         TJZuocxrZGXSB7oRXeXOS7hlVnoFtWEBZBJs/SXfhQdQDqyp4Ut7mwFVXE7uxyeQ84up
         z+xY2Ck2XuaAZZ696n7xdMr5SvejO18unkFjr8xOB2klu+vDWPZmMfwqTunb5TzwZAz+
         Zo8A==
X-Gm-Message-State: APjAAAVbVTcUZwAhJ46xdwUF9PlEaa4+x4c4a+LPhfJWF+gBLipRnwpa
        87BoehIdZC0mAh/LPmQAqq5ewUatI7c=
X-Google-Smtp-Source: APXvYqydpELlHWZsigFFlqS5Am+ZFF/LFQli++DBL4h2a9aNOWq1zcqIIlv2zig91qO21AmzMvIhDw==
X-Received: by 2002:a65:6090:: with SMTP id t16mr879948pgu.2.1582071185330;
        Tue, 18 Feb 2020 16:13:05 -0800 (PST)
Received: from [172.20.2.58] (71-95-160-189.static.mtpk.ca.charter.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id z10sm103546pgf.35.2020.02.18.16.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 16:13:04 -0800 (PST)
Subject: Re: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1e4fbbf0-5b2e-4372-758d-55e9352d11f3@kernel.dk>
Date:   Tue, 18 Feb 2020 16:13:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/20 2:19 PM, Pavel Begunkov wrote:
> io_cleanup_req() should be called before req->io is freed, and so
> shouldn't be after __io_free_req() -> __io_req_aux_free(). Also,
> it will be ignored for in io_free_req_many(), which use
> __io_req_aux_free().
> 
> Place cleanup_req() into __io_req_aux_free().

I've applied this, but would be great if you could generate 5.x
patches against io_uring-5.x. This one didn't apply, as it's
done behind some of the 5.7 series you have.

-- 
Jens Axboe

