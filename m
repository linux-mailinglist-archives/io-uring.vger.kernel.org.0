Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D131D6CD5
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 22:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgEQUXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 16:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQUXy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 16:23:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75826C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:23:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so3790069pgg.2
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jXEySpPTMdlRfT9YbUl066v3PKhZx3NgNveD/Wnf6Rw=;
        b=NcKePph/JZoh7TYicq/W/AdFarowVnhDby0fEn9HqHcyhmX/UNCyHpVWP35PSUD0ml
         zGfcY5nJUG5yQixRmjOpKYznT+EIUx+MDKcgLv33jg13hZ1oIH4mE+iJ+BNd0pAqrjxC
         Wwf+QZmWERzrZ1ZtjcZMJ4y1oH1X5JHHYMJsDP9uxUvvGyDP7jQ16d5Wuoda5ERusMJm
         PcsikTzd47/rO6bGC/FHDaqihyDPgrmurKVsSdBIdGCJ+x4+qrDll/WQZGYyPCNjFnOD
         9ygf2a8ytjWtJisx3IE+7M5dtWQ3wHYEhDmQIUVB2Bsk3f8JZUaiO2MhyF2fqWCqL3uk
         b5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXEySpPTMdlRfT9YbUl066v3PKhZx3NgNveD/Wnf6Rw=;
        b=fODFH3RxpYnaDbbo8UMt/aoXN0eo3lXtTCuieM5n/LIjtvpgO7nmiHmVJYc04QleqN
         DclErzuSsBAaZ4nOURhEOhXymlbKOeBnP1dRXo1gr3Yn3Uo3jxKx37tbY6uPw6ZezkBf
         MdTbx7jbYLT24Ru8aSCaJ7Hl5PNX1ruNOeEOPJM2lduA6TMj5emVsh64APzTM2R+w8MX
         21HyA1u538hAAGOuEO7hCHHh+Gf1If1tMLYeIGKHdo73HhnJ62l1rVfH5yfhkb9k83dg
         mmB6eJc2mPqPoJVX4mh0yTZiZww8vktyYTNTD4Sguy9fJMHfwijD+Af4DxDN25/JMhYG
         iY3w==
X-Gm-Message-State: AOAM533rmlE2UFkJp4JfIr6p/JUTw4sdJfScLLNX0ygWJtgQbMw21xsg
        t9YDr3RdfeB8MzvM894VkXnV1A==
X-Google-Smtp-Source: ABdhPJzdngS7lHPeckbG/CrFShueYjUqUMWcQwpMVm+nkutSi1kSIriVn7nG6gSJDk8DIpkaYfrlNQ==
X-Received: by 2002:a63:f412:: with SMTP id g18mr6158449pgi.276.1589747033027;
        Sun, 17 May 2020 13:23:53 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id s136sm6898130pfc.29.2020.05.17.13.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 13:23:52 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] io_uring tee support
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1589714180.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7737970c-cf2f-c96b-2451-9a84b8846649@kernel.dk>
Date:   Sun, 17 May 2020 14:23:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1589714180.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/20 5:18 AM, Pavel Begunkov wrote:
> Add tee support.
> 
> v2: handle zero-len tee
> 
> Pavel Begunkov (2):
>   splice: export do_tee()
>   io_uring: add tee(2) support
> 
>  fs/io_uring.c                 | 62 +++++++++++++++++++++++++++++++++--
>  fs/splice.c                   |  3 +-
>  include/linux/splice.h        |  3 ++
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 64 insertions(+), 5 deletions(-)

Applied, thanks.

-- 
Jens Axboe

