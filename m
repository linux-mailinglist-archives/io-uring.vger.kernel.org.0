Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2593E4D3F
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhHITsQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhHITsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:48:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A62C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:47:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so861916pjz.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oyJUFSUL8kMcDHVKuGuq0T1EfPENUEdHg2FhixB9ZRA=;
        b=fXfKMeTl/pwEMXS/dYHQEUhReukrrV7D5a46VWfaPOXOEXuAIelN4/NQ775SdpnyF2
         opPgYERbiKSEwGHzShO2rganlQMT/vjfE3zGW2RS0V5vpGi4E5gUryRyd8COD6frROCg
         3aD/6sYlc4ABG9ZrbfPxIo3DH+EwyrDRy/taGYJCr1kXznD069JbLZ8zFwNIC3D5dXzK
         9Hhn48kCAO/7HHVkJkhlj8HODj27uoKkxM7DA7E9eBA5KQwMYATQs+9/ZriDalK/9eD1
         DEbmg46c2IGzpzxusUHHSwfFd5IyQrK5m0S5eKrZtxTC2uSVIT8BtjTk+px7ardJbDI8
         yzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyJUFSUL8kMcDHVKuGuq0T1EfPENUEdHg2FhixB9ZRA=;
        b=aIEToSZIEnRr0PZ88KVmF0bRk12W5wJfhH4RnVI3jk+Ha9Yd0xPVdhY8PNVM7Ofglt
         ANufqwKDVTSUrt3rsbifUDWIEHR39DKiJ+nWK0DENICiDlNNauhGpwYGXkGNrWeKdscd
         eYD+0xqJ9TeDLahn2pynbeAFNWP0qztfVm02akWSKTKOtcDrKcv/x37jj/diyTkgAA4J
         6exeh8hIcdQTs+EIGUVGr/N/XUTqcRYvjBxRQw8cd4vEXG/vWFBxEwHlVt9ZL7sfZBin
         C/4WeSQ59DQ+XHHt3aEmVhuZyErkNcAwLX+EtmOLVo330yIhcqGX62i4R05T9MVUXDBF
         lRlw==
X-Gm-Message-State: AOAM5325+wpl7uSWZDO+YdOAQkjKz+oyRyoEArbyjngWi5blBj+o5kO+
        xWhhv3JwpCed5MF6E9o1Zi5RS6D6RZwuQHsw
X-Google-Smtp-Source: ABdhPJz5y86ncbD0qny5AKCxEDmdUToqpr0MLGNv/49QR4BOV+i3DnzF+EwyFOknRJLs1GHy4FSsHg==
X-Received: by 2002:a17:90b:1d09:: with SMTP id on9mr26094211pjb.184.1628538474184;
        Mon, 09 Aug 2021 12:47:54 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id b12sm21755618pff.63.2021.08.09.12.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 12:47:53 -0700 (PDT)
Subject: Re: [PATCH 0/7] the rest of for-next patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628536684.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c222ea3-45f4-8754-a000-d09e093ecc89@kernel.dk>
Date:   Mon, 9 Aug 2021 13:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 1:18 PM, Pavel Begunkov wrote:
> Resending the tail w/o "io_uring: hide async dadta behind flags".
> The dropped patch might also conflict with 5.14, so will be
> resent later.
> 
> Pavel Begunkov (7):
>   io_uring: move io_fallback_req_func()
>   io_uring: cache __io_free_req()'d requests
>   io_uring: remove redundant args from cache_free
>   io_uring: use inflight_entry instead of compl.list
>   io_uring: inline struct io_comp_state
>   io_uring: remove extra argument for overflow flush
>   io_uring: inline io_poll_remove_waitqs
> 
>  fs/io_uring.c | 140 ++++++++++++++++++++++----------------------------
>  1 file changed, 61 insertions(+), 79 deletions(-)

Thanks for re-spinning the rest, applied.

-- 
Jens Axboe

