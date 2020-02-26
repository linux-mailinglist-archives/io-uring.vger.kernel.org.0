Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9491706CC
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 18:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBZR52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 12:57:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46102 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgBZR51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 12:57:27 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so1559817pll.13
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 09:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6lCBRJHxILtlBMBMgHNIBxuMksjdXmg41id0iaHws1Y=;
        b=tUsY4o3nnthNNOwIuWq+KImwOyjyKM/CGKm1DT/kYPAugSd8GzFVHmrIQQgm3yV1Cw
         VtHOQV8cDAUcVhKFpznb8yY+xSOMIa38X88+2LTCpaAoXcqHDjIoseNQLiDpoDiKiuBL
         ONvIXy83R6FkOnNj7ptb0eMPH65xncuV9o0iail/XwV9uYoTMJ/LelmJUOdoq8o911FC
         Pip7kh13GGz91Iny92ezJr6e4dlNaQIIJLec/7z3xNveQw0o86uVYi9PNGynKHW0DEYu
         WhZdpgPBDIku3wQkU7bAODrAnZcO/qvEoKh13A/BUHTUllvVqnz+hrZ1aifYFBRSiP7F
         vy5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6lCBRJHxILtlBMBMgHNIBxuMksjdXmg41id0iaHws1Y=;
        b=RNJlTguN7CE0HNN7JYYk1H1Nl3uUftBAmG7cL5hhwVhAJGnxTlENtDT9OmRLiWXvJ8
         bUm1R5kluZOvwuSfE+Xv9Y5DsSqfnX5Ej8lRGUSTFc5sfDgkAEou8A5j51oi0zWKb4Hf
         UZl5uNkTf3VPZIDEWsP5eW+aJB3bjf/v9NjrbrGVGUacsuAZT9ncNauc/jTIs+ovCYms
         fCrfMP2RERk3ZXcBcVnmfemuiVIXChvWvhvybsGdwW8MDNmqxzPx5VyZyYPrWE0VrfsW
         ugTMj4/I+ayhQc2LFJ9dHqG/WDbZnJ2U/P2Rv/4yBmgzyg/qcc/sjpdXGOzP6XKifQUl
         QA6w==
X-Gm-Message-State: APjAAAVVmXP5PjPB5l4tf7FgeOQWihG5KgYyBHBn7z78/um6Zt5fL+Va
        9UTYyGWDTaK41O52p5+VxiaV5Mkofb61hg==
X-Google-Smtp-Source: APXvYqzKwYSguaJk880MumsTaP1TMVBO3dyCQGxRmb2GrDpQ/aBeBKmUBXKD50GeaibasI1/c9zESg==
X-Received: by 2002:a17:90a:b386:: with SMTP id e6mr283244pjr.106.1582739845786;
        Wed, 26 Feb 2020 09:57:25 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::137a? ([2620:10d:c090:400::5:890])
        by smtp.gmail.com with ESMTPSA id u6sm3488199pgj.7.2020.02.26.09.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 09:57:25 -0800 (PST)
Subject: Re: [PATCH] io_uring: define and set show_fdinfo only if procfs is
 enabled
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     io-uring@vger.kernel.org
References: <20200226173832.17773-1-tklauser@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2d92176-abcb-fed7-d3ad-862db83e0292@kernel.dk>
Date:   Wed, 26 Feb 2020 10:57:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226173832.17773-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 10:38 AM, Tobias Klauser wrote:
> Follow the pattern used with other *_show_fdinfo functions and only
> define and use io_uring_show_fdinfo and its helper functions if
> CONFIG_PROCFS is set.

Thanks, applied.

-- 
Jens Axboe

