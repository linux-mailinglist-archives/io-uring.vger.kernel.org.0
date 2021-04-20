Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0197A365FDB
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhDTS4c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 14:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhDTS4c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 14:56:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E8C06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 11:55:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h20so20184390plr.4
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=a3tfQ8wFQHhKhpo1TFjo3rYntWnNmHiZLjANDockoM8=;
        b=I2ZWx6SXXvAf0Eigwmd6pAezajGnKSSIO/1wNVNJVUBQ+Lcct7IoA1V2gUkohKNNWS
         Hvo6shLjnfbZnJMahE5a62hX/7fTOmwhRxiIEU7CZuwVJblwygBL4Kh4HyqD8BXAoZDb
         Loz5AmqYFWO9elhGK26Fq6Oaz3o3xxkYtA13DlntbHphBxqyGq5r6GQSKgtSHMvQHc6w
         ytPy6GMHLtbJxBcOJCGeyVA/vJJyAg2FzvnQIx/WcNsDtpkep1cW//s4l4r451AkToG2
         Snn1VCCS7f5QOLzovJ5NC2GsKol+A7pPVZ/9TJ1gtZyeKiXIKK4+XiO7pineCk4MFvfS
         uzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a3tfQ8wFQHhKhpo1TFjo3rYntWnNmHiZLjANDockoM8=;
        b=Vz/rbaM6ul5JdzgjHrDRwxs6S8Fl0IH2bKPSdNZLTnzBZu0jGzJQ+pIgQXCU1QR02k
         JtYNthoT2HxlgM5w9gCHfg/uCicru7nXuGNKtTSRZIJzWBpfirEZQEgCRLB41686ULNE
         kgVkibV+/C8RDJe14/T5+bhNKUa9irlK4IpRAFheXxGTIUNuiEPBx2BhfKZ4/MMvezy6
         XVHAE0y8fsGFs3A1YTGG3OR+1pLvlmntAapbaWO5TaXgAFHugo7wqOO9BsZBh6ml9eAf
         hHj9aKy1R7h4JU+c1WaBdduno3YTEJBJSLYY+tywdX/DeElywm9k1oz5EZku1QqMqBgR
         tWpA==
X-Gm-Message-State: AOAM5332DgT/NXDmxcqjUgM6j/hreaeGRFIPU7w0NoKLrdGjRqIEGyQw
        f+SeEnWjOrzlo7m8/+aAU+3GLQ7Tw+e31g==
X-Google-Smtp-Source: ABdhPJxxk64TPKRa/x42V2J++jdN9gW0Hga+pzrgcTMmSq3T1OIswqgSRKlEeXiQdSKZ0zhNYZz/zA==
X-Received: by 2002:a17:902:e74c:b029:ec:ad88:4bde with SMTP id p12-20020a170902e74cb02900ecad884bdemr9347824plf.75.1618944958486;
        Tue, 20 Apr 2021 11:55:58 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e7sm3095277pjd.6.2021.04.20.11.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 11:55:57 -0700 (PDT)
Subject: Re: [PATCH 0/3] small 5.13 cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618916549.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9be094b9-922e-2722-c3aa-5eff2fa5fe62@kernel.dk>
Date:   Tue, 20 Apr 2021 12:55:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618916549.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 5:03 AM, Pavel Begunkov wrote:
> Bunch of bundled cleanups

Applied, thanks Pavel.

-- 
Jens Axboe

