Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3215602F
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBGUxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:53:08 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43045 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:53:05 -0500
Received: by mail-io1-f65.google.com with SMTP id n21so966819ioo.10
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 12:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gPAsDsH3JFu6Z/PO2T9two+jAgepbuUh+wb+Brcdscg=;
        b=jFDm3UdTaFobl8KlNZ+xx/OQpMdMEP0sLcKc6IIsBGRY/MIihU7Mgsj3q9XSgoaByQ
         IU6oR72HeXUVoJaDuENimaiQ7FTTNbejEkhdfZwIZyu9m6Mm1FnNkx21JF40GvLdA8up
         sMd1yFJAgN7UWzMOKXCKHJt7RseuAcC+5iy2+zH7w/fGdzGSQvfDPrPqxhbSdyKNiqkA
         c7pscdNnS8SSX8s+Lyulp5Tw0IOKY6P5OcwHaKiYrAKa9rXAqVnAnUgjr9A4rfkvj8iT
         9n5yYTngI3LNshykuhlFAnyFnIeNg1OfWy44ZA22zeWnM7dMl6mxqY3H2FpdW3eYfNve
         vOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gPAsDsH3JFu6Z/PO2T9two+jAgepbuUh+wb+Brcdscg=;
        b=bxqR2iG3W0C9ye43lbHyGidHIpmIRVCPGZy9RKWroj7npUtClN4Q00ITYahMq6Et+R
         y0HJSRBRquMejqngxGOcbB9HX6Kny12ErpMXdqeHGtAjwjM++T5FNoy0Y3RvcOKr/54Y
         YRkmGZGAuVumctZSLANIltW5ODKpnkHQfgsHh2+4V689FqCRWEX74aAfCBAEHkcEa5v8
         Oz0HMBfoKkSRKhAVrwxhvsSr7PU8eamHcZpb6dNSdY666/9zhU8MrS9VtdVml8jWqOBO
         AU/PlrW2GqVs8oB6Ljmn4iVzmVaLExcMx/QMGhTy9xZlJIcFoxD8ZL79tN6oE1f1lPVU
         Hglw==
X-Gm-Message-State: APjAAAUoYqCpxY9iCZViLe9jil7ZsNY0AXzMi0HsBHnB+VkELDHieCqj
        VIpBMJWGCiNUrLz633j2wsWVs4DV9GY=
X-Google-Smtp-Source: APXvYqz7ZNMHOg1C8hfC/YMMf42JDYx7SFETr40yRf70ihInQvE27y8HViPZNxfvJ/97hsDMMlTpeA==
X-Received: by 2002:a02:ca59:: with SMTP id i25mr323779jal.102.1581108784007;
        Fri, 07 Feb 2020 12:53:04 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l81sm1669041ild.87.2020.02.07.12.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 12:53:03 -0800 (PST)
Subject: Re: [PATCH] io_uring: add cleanup for openat()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d3916b5d2c04e7c0387b9dce0453f762317dd412.1581108147.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6729b8f1-f048-8cba-8a7a-45ef1d8c3256@kernel.dk>
Date:   Fri, 7 Feb 2020 13:53:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d3916b5d2c04e7c0387b9dce0453f762317dd412.1581108147.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 1:45 PM, Pavel Begunkov wrote:
> openat() have allocated ->open.filename, which need to be put.
> Add cleanup handlers for it.

Should this include statx too?

-- 
Jens Axboe

