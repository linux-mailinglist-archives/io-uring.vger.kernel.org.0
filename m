Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED2B30B172
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 21:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhBAULw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 15:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhBAULu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 15:11:50 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3B9C061573
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 12:11:10 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id x21so18774906iog.10
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 12:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1P54cXlNq+/2gHlGze3HWFPQteT+oTrtu5HeA6HnTbc=;
        b=zILj/CnK8PuURACB3t/7GKaGXVYAUyS5fi1JKnoH49pq1y1HZYxG5xtAX7w9XWJh7q
         ye390oXWDXfXothZDOhVe88A/nSkQXcdDk1IVRu6bZxNSsyKDqeNHcGSyl62aCFZQpTh
         DASzYcabX0bNdQ/SvtuM4/IEXrQniTjybkvmOwgDJIrrPHKbb/XAPnXaJPQlw0End5vJ
         n86mATJeaNLs23Upa0L0ZS9/qTPro1UFxDhEBGFm638e9khJ/nrDAgzuHFgLTqI7rWFk
         e2ix4Uvfvx6bWICvUUvwTXc5CEneh7Ju3NjEtq1ByCT0jryW7iL20fTu9XwkEpd34kgL
         V4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1P54cXlNq+/2gHlGze3HWFPQteT+oTrtu5HeA6HnTbc=;
        b=m2FKnSIKAJj5nfJYM4m/noKHisqKuEYz6LS8dZLTOtqrGqgDavPx20O8+40m5ZZDHt
         J5wNL2WKlLPuvqahzB3cmYetO3ypyqOC9RqHZG2NCbsXamzdTW/psqJv5a59Do0QSbCy
         j66RnyFQ8v0gKv8AFNY39O6N8ln728Kp2Qt0c73yqwLQaPvqhVti6oCd/c6hdMDs7fBn
         J181LyRYNh2MQetTMPyV3jwINyeDJYoZYm0z23ezFduCA9P3uQtxiuXzrwhx9DNq9fZu
         GyZ+9On0fLH69IvuWmHEqU23kGmdOmUe42/Dl9PBmW/vASdgMndhJkW3dBbQAQBwIk6x
         2/kA==
X-Gm-Message-State: AOAM533YtxeyUGh5eAiJOXc5hQuMGW0O2c50XWQnu9HafQBQ3QV8KsM4
        NZAjTTIAPBsDBSofGbU6Gx7bbDhTVo2ftIOV
X-Google-Smtp-Source: ABdhPJxTLIkDccrw3ons+ArNUXoTt2XM+hsHnw2goZidbUOxDffNt/2ikYFsLaVJw4NAj3DxyqNCbw==
X-Received: by 2002:a6b:7e49:: with SMTP id k9mr5103088ioq.181.1612210269305;
        Mon, 01 Feb 2021 12:11:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q19sm6003921ilj.65.2021.02.01.12.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 12:11:08 -0800 (PST)
Subject: Re: [PATCH 0/6] for-5.12 stuff
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612205712.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <616e3acc-c8b0-d8c1-6c1e-ff9d7b3d376f@kernel.dk>
Date:   Mon, 1 Feb 2021 13:11:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/21 11:59 AM, Pavel Begunkov wrote:
> 1/6 is a for-stable fix (syzbot).
> 
> Others are the first part of 5.12 hardening and random cleanups.
> 
> Pavel Begunkov (6):
>   io_uring: fix inconsistent lock state
>   io_uring: kill not used needs_file_no_error
>   io_uring: inline io_req_drop_files()
>   io_uring: remove work flags after cleanup
>   io_uring: deduplicate adding to REQ_F_INFLIGHT
>   io_uring: simplify do_read return parsing
> 
>  fs/io_uring.c | 119 ++++++++++++++++++++++----------------------------
>  1 file changed, 53 insertions(+), 66 deletions(-)

All looks good to me, thanks!

-- 
Jens Axboe

