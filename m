Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538D1219044
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGHTPu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 15:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGHTPu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 15:15:50 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D4DC061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 12:15:49 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l1so6271025ioh.5
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 12:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G6EbXcVyYEsUMBIz14DNe27S0g/BGfSgrd9wkD0hMhM=;
        b=Ec0p9V7lskZAd3VrNhslvTyhOgWGUacuHL9OdOKf59yOIRsT1fOFUXaqtPKbWniOCA
         pcr04q3HZEaOTvUghPPTflbxoTnLJYTLsKRaB9CT6SKLKuKESKWphDO1GlN6EFpnkRkA
         d5/o8ankakO8fSVuq0NwgT8CkyC0Tm/qGgAABhKdn4nwGDsZV1Z0qKWwRLSog0+0Qnbe
         6vXRciAAsjFTcYCsWEk2LLoYRhK948qmI+WRaxITBipDcTVvfuPVunZeQPXtdanZoI4v
         UBXCtUVA2qJFJHDRAROuZ+pv1eJKTFCWlGa0XMvmtSKaLS21xdV3Gai4q//uAGi3QqtF
         PQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6EbXcVyYEsUMBIz14DNe27S0g/BGfSgrd9wkD0hMhM=;
        b=qwscgscfN8cQ3IdbOzRmil/daBk0s05y4INlm/8KUsZS8o3ha8V2M4DNXKIn7+P6RI
         tJyh3wQc5EQ+k5r9lUn5U0r2spQ3FusU9IxlP8vrxeelya5hW5VfliZbUR2Q+W7Q0pqI
         IQrisqZ0qvg6rAHVfrZDtXlJD8FPB4nLGZWwAoXXQaCeSs2NqQCJcvur0eAfyy/dhJ5c
         hIu2gGkpRCV/QEc70/kCOhjGcI0FKZu7K0mzKCWAjePc1vInD/JKSXoQnovr0gIHClJC
         5pbLVPlU9i6qLCB6KndJcaF+NmnWd9k5LiYxwm5mCMybktqRPAFAD3rFmNRqz7flzysR
         Ynmg==
X-Gm-Message-State: AOAM533FnN0BmEWiqcFe6OeH/syZvEIgtJJJtc2R37Df3fvUQZTwk7f5
        bfWLhujburQ5T6/QHe/6j1Bs1Q==
X-Google-Smtp-Source: ABdhPJwO/NTsffQFy0va62QN1Tl2qDwwkeZ469kY7yrBfR3+c1hWxw+u7D34MpElyJ3fImdVlRuGbA==
X-Received: by 2002:a6b:8b11:: with SMTP id n17mr38074596iod.155.1594235748854;
        Wed, 08 Jul 2020 12:15:48 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e1sm410263ilr.23.2020.07.08.12.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 12:15:48 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix a use after free in io_async_task_func()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200708184711.GA31157@mwanda>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <58b9349b-22fd-e474-c746-2d3b542f5b23@kernel.dk>
Date:   Wed, 8 Jul 2020 13:15:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708184711.GA31157@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 12:47 PM, Dan Carpenter wrote:
> The "apoll" variable is freed and then used on the next line.  We need
> to move the free down a few lines.

Thanks for spotting this Dan, applied.

-- 
Jens Axboe

