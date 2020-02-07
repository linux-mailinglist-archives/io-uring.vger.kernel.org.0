Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B66156094
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgBGVNM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:13:12 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55927 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGVNL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:13:11 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so1435291pjz.5
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 13:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6EzOdMFQDDyqSndW99ah55WjF8ZUkRxUPd0ynxNiAwQ=;
        b=LYKwR+mRTMNgXNB/D1PynJqHkuZYdx5csduEGZ/anaetY3PVg9+VudOmIl9A3EeAWG
         KffLLDcreSmN1Im4K08hw/z6DQxQvXromzoSEVlinOAbvhi2Nh7OLRCp3WTRVol46dni
         Cko8Dq83VcYZZew6cabUU4OgUVKvx2mJqMAY+O2paRCjgmOhI/vqCadFZdBGj8ZWqvci
         AbPsJ7YjsGrJz3snXz4iKSQKyaXsayoyDI1aD4DW+U4efAwDGIFyv69Rz/6laovbX8/c
         0D66n1Bfrje3dH6sAT4ya3SCxt019BSULleFYDocpjI57I3G1NEfBaW3jEYEis7CG3XC
         K8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6EzOdMFQDDyqSndW99ah55WjF8ZUkRxUPd0ynxNiAwQ=;
        b=rnz5x4mdqCBE2Tk7qbfv4lleCe4UXYZSvcw06qDN3XPYASyBwKLE7BB9u8jaqvZ08K
         hRrb4yeVcVomU8z86AQDQwkA+CsPalAcZsGf2hOKq55NBsjSxFcaPGQ4oSMFgJnX7wKn
         3ZgpPAPb/KUP9CkRZA8vVV9C0/3Zf/6eeMee9DP3Jb9Kl7LNzK1WMpp43HTERKSObVXG
         D3vl3RqfG+/Zz7/3ebns7gry6fragekvaDWpeCaIY/Hr8kbAe2VbChSfKNY7abrEtwxH
         xA+WYWrtdQi2NKEZBS2XBCblvxpkKSyvrWCDUp77aecmj9YDSQm+z1bkJHihIOwA6sZG
         10QA==
X-Gm-Message-State: APjAAAXz/CXIMLjkhk4+9wDhgiGDiXeXuG4Am3EBJMpjwMlJCkQaCa3Z
        r10s8sJDTADNH1tmkNqQ/CBiriztZlE=
X-Google-Smtp-Source: APXvYqwGwVEsK4LFpP0ORfn0cPPiJSL8KAXjCextfhEASRuNfp0mYZ/S8eIv0N7Al1Wq4BWhjtlGbA==
X-Received: by 2002:a17:902:fe93:: with SMTP id x19mr299090plm.155.1581109989661;
        Fri, 07 Feb 2020 13:13:09 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::134e? ([2620:10d:c090:180::3860])
        by smtp.gmail.com with ESMTPSA id r26sm3903941pga.55.2020.02.07.13.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:13:09 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: add cleanup for openat()/statx()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b55d447204244baca5a99c53fb443c20b36b8c0e.1581109120.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <10b7caed-06dd-f6a0-24f1-648968011e40@kernel.dk>
Date:   Fri, 7 Feb 2020 14:13:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b55d447204244baca5a99c53fb443c20b36b8c0e.1581109120.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 1:59 PM, Pavel Begunkov wrote:
> openat() and statx() may have allocated ->open.filename, which should be
> be put. Add cleanup handlers for them.

Thanks, applied - but I dropped this hunk:

> @@ -2857,7 +2862,6 @@ static void io_close_finish(struct io_wq_work **workptr)
>  	}
>  
>  	fput(req->close.put_file);
> -
>  	io_put_req_find_next(req, &nxt);
>  	if (nxt)
>  		io_wq_assign_next(workptr, nxt);

-- 
Jens Axboe

