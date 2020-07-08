Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBCF219281
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 23:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgGHV2S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 17:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHV2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 17:28:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28251C061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 14:28:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d10so6680862pll.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 14:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=tEoGjidUI2i+E/UcNZ1ujmF4nef0yOFYLd4rmcIPVL+quLgxc4BSYCHMfqRUlWfYFG
         zR72a5kz4UDmGIudqlHSlxMDVpVSIa8F1AfgwpGYZ/jcWwg88paE7dl7ljR+78EOG00o
         hxfuFvCaN6f7ifY2SnOO47jQXmVClDsvNFLKSgoRmkKBYs9nFV0g7ZS9Bb6MzSKksVKU
         nfrb45ULYroDEDujnunUvf2uE+Q/YhwRbKV52sF/jFG1ypPY1z/ew2sJq7pbD1W1584L
         RNDaGZpDwDS05XxoDhmDViphCpTU9K9ccdpyL/UN0XKmigq1Wlya3EP5Gi572vrv5Hag
         bdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=DdZXrZYa8STeAr++HBGal0Bhm7/01xGvROKYhMNiDbtBQAFgBqc+BChJBhLbS1ba1m
         ocTzZBbpW8AlsexBPIbZOC+V27A9My6O1CYDHS55ijvZyhTUsR9vE7VrYcdLgznO9nzD
         UYBeL8haOHHFPsGnrQGcrd12I23z248AkPWd6LkBSJDs39m2fyssbgjGAZ024Y4nbvqB
         QgjO4nCfBtdpI0H35oLIB9xnN23m/LX7f2KUvXE7eLWZt801t8d9auXTsLNkbyLS62DK
         CNYM6T9PmP+zUN4mkYQWnvCLXkeA8292MiC29duU/FpIUmK7xw2LWROrXApJspM8cbMG
         bzXA==
X-Gm-Message-State: AOAM532FuNp/NwTzZf041KGKT8+9s9DhZDFuyWQolDY8lBagowqTuhdJ
        bdA611T82UrDUePxIMSy9TQFIrjA8JP3nQ==
X-Google-Smtp-Source: ABdhPJy0gXAJfXkD+yy/6q7nzEwc5aZCZwYPnNz8Skd/odklBvvrSqWbjp0zSYKPYiQ/N/BACXKm0Q==
X-Received: by 2002:a17:90a:d3d7:: with SMTP id d23mr11388777pjw.232.1594243697133;
        Wed, 08 Jul 2020 14:28:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 66sm639795pfg.63.2020.07.08.14.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:28:16 -0700 (PDT)
Subject: Re: [PATCH] configure: fix typos in help/error messages
To:     Tobias Klauser <tklauser@distanz.ch>, io-uring@vger.kernel.org
References: <20200708212550.20708-1-tklauser@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <361286ac-799f-d8ef-3859-04e63584e446@kernel.dk>
Date:   Wed, 8 Jul 2020 15:28:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708212550.20708-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe

