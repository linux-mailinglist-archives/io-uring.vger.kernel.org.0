Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8EB145D65
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 21:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAVU6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 15:58:25 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46948 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVU6Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 15:58:25 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so653223ioi.13
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 12:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4MircL4o+/KcGaydQPkSmj2rWDThvm1wQe092xveFAg=;
        b=z7zNVoDLPM4MKPRvTM8UcJmi0wu+n3yp7v7+XP9SWb4hRXrNU7h3WCwDGc1P4vU/pr
         1RDsoi29ohD4qtUcHvQ8YVj3VQwls6+TFceX3zfd6HPZyLZ5d2nUYL1gwbItGly6YDQ/
         S2NtkRpr/cc2n/3SgaFMbvs0eS168OjavvQHzbbqmK4j9iFfDgQTEmS2mHsV2YW0RcMW
         zcBAMt6NxOf8u0r10Zm4RBnrYnA+JWTjw0JMqfRjiaz0aHpWK24OVvrAWbwynBgiDRUy
         W+ArAyPuMeakUhlPKLAWTElfVmnwEmTSFh/F8/UOvrdl3yM/7qU6GShXUf03Hoy7DLmn
         ORLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4MircL4o+/KcGaydQPkSmj2rWDThvm1wQe092xveFAg=;
        b=JQkVyJuSJtcOg7I9PeKLxNVqjthRC/iL6j0AAzMmj33bkYtL3J7YyM9oYfvlxd43RX
         Vn8Zf2fsJD9G5DOZpkd8h/qZWEL25pBY6dJpA2FSvfUWCPLuFaTsIHnJNzyfqBZNR3Im
         oaR7K33uhn/MsPBLn5pBP+EVL588oIL5LeeQvWzjekkLj/YSxFDhWlhF7V63FNg6ZptX
         qy66pGS2KEPBrfq+YAmXlDn6l3OrXE7oHvF/3nfcXbzoHs0sKRcrZu9ECXQ4D0DXr1aI
         DntY75iZl1hIi8tI039gN6KO1eVP3vy286Dla+4UbnHa6pBZ2M1QQg+veAbRmqwvAOea
         GSQg==
X-Gm-Message-State: APjAAAUbd8vMl2HUcTkhUhZPXX/Lv0AoShSFggY3pelY8KPsQYfDPSRH
        8AdCjaKxmlDis8NYK8kNTgZ8/g==
X-Google-Smtp-Source: APXvYqw1ulk/Wtf9YIzcaCdr/v609qPcVtLz2wSTPEoZNUkQaI5ybUqWCdtoDCzopR4fh1M5bypPMw==
X-Received: by 2002:a5d:93d1:: with SMTP id j17mr8768497ioo.300.1579726704741;
        Wed, 22 Jan 2020 12:58:24 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm15020839iln.81.2020.01.22.12.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 12:58:24 -0800 (PST)
Subject: Re: [PATCH 0/2] IOSQE_ASYNC patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1579723710.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5722c4c7-ac5d-9a28-62e8-c327c6affc3c@kernel.dk>
Date:   Wed, 22 Jan 2020 13:58:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1579723710.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/22/20 1:09 PM, Pavel Begunkov wrote:
> There are 2 problems addressed:
> 1. it never calls *_prep() when going through IOSQE_ASYNC path.
> 2. non-head linked reqs ignore IOSQE_ASYNC.
> 
> Also, there could be yet another problem, when we bypass io_issue_req()
> and going straight to async.

Thanks, applied.

-- 
Jens Axboe

