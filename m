Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7E1C18BD
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgEAOtZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbgEAOtV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:49:21 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476CEC061A0C
        for <io-uring@vger.kernel.org>; Fri,  1 May 2020 07:49:21 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id i16so4624372ils.12
        for <io-uring@vger.kernel.org>; Fri, 01 May 2020 07:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x8PLshh029JFfraDINPFYaqpVRTVLoh0xA2vag76VgU=;
        b=vxEfLCTH7Nfxiz/d41M22feQyHk4l3tlyaCNLOv6T1fKQdSeNDrbCLS6eNnGqHVhbh
         6ApTEFX3Wz8cNujDJ4T3JDlFpqKvn55GEy0NwGKXU2oXvAVoLr6rYtX83gJTQNEOXysP
         GcUsze7xAEmat3U1O2mU14fW4buR0xIeUS2pH3KNwqCI5aLmZ4c+vHNpK5fOCQHOQ4ni
         4vB/IsXHNGfcSJUCqwwXmdkbT3Yhis8V3NVRu4I2T8YkVdIP+Co/YOEwU2XdlfuO0dgv
         5lCprRhSsRv3vuPsX45tP2XmfOHQxFtLj28e2dqatilMymm5DlkAmHZtrhFB8Map2qZD
         w4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8PLshh029JFfraDINPFYaqpVRTVLoh0xA2vag76VgU=;
        b=sXzoLvcUoZM9xFqzI0MVvq3ptgklSBtZ4Wi8dfHSIA67AsjeAlizh1kFOpexNCkAb9
         kSu2998jJ3wNEo28q17rouU5T7+vkThY+cO9W8SjjHpGTU7IIdfLn9XV7CM3Iocp+jlT
         T4dbv1d1Pu+nVE1khwrlRkxLBNzaj3pAZk2Y/3Dga4eP0PuLs77HMvu5KOkCYaB2yBRU
         mqSsKO4ZlyrR6r2DKWN5gsY4fulass6S7u2YLDqcTE7ThRNpfoP4goXpy1cN4Tl+KOD5
         1uzyTX53u/LDvmTokPfsEzwgXZccQN6YSzOsdwUAzmZaRFBZohzUPBkHfFGqHzJs2wuw
         eSlQ==
X-Gm-Message-State: AGi0PubThzkSUaDYMCzAbyYtWAykQMVa4ZhikJSaOZGB5ZxXyMqJyPOZ
        oYV8lcXOFZHnnifcHg9niGYFBqmlUQuShg==
X-Google-Smtp-Source: APiQypKn+TEanh98F99uq96FudsPyLXSW6MEPEmMn6erLQrIwYFY6+FIDdMf1z5efsEtucHKAzzGKQ==
X-Received: by 2002:a92:c6ca:: with SMTP id v10mr3870302ilm.181.1588344560532;
        Fri, 01 May 2020 07:49:20 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u21sm1018966iot.5.2020.05.01.07.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 07:49:19 -0700 (PDT)
Subject: Re: [PATCH liburing] test/sfr: basic test for sync_file_range
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9a85a351b8a06108260fee1dfcbd901b8055b9a8.1588343872.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6fdbccd8-80ed-1e5a-cbe8-2785967fd210@kernel.dk>
Date:   Fri, 1 May 2020 08:49:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9a85a351b8a06108260fee1dfcbd901b8055b9a8.1588343872.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/20 8:38 AM, Pavel Begunkov wrote:
> Just call it and check that it doesn't hang and returns success.

Applied, thanks.

-- 
Jens Axboe

