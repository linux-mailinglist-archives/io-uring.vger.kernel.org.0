Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9F1A01BA
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgDFXd5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 19:33:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40858 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDFXd4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 19:33:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id c20so8382786pfi.7
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 16:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=APdJ2bbJpdKbX+Sk+LIMoTdwNG0LJpHDXmC1o7gJlEs=;
        b=msdjWJ+QJBaucO7GD9Jl+hBSA0PUl2BSJiwTwyO6NYTKgo++vqVg0TAlaenuKxaTZH
         GYQsp2YXDWbKyhaXMpwDDw/f8KKk2nByDrmkaR9QtCgoObBvBvsJovisx7niVMxr9702
         HRN6s+4JhXbxnccjpu+npnHfsUlpmPlkRjJSupNg44UW8zSTOsACZtlAYb/VLrwdf8Et
         xI+Hq3cQG1FvhxS54t33C0gsvLaBf9S7l6fbWaRVz+bq34EB+IoQoBhXm3AQ+gdogGfb
         O/2EDSjYBb+Bh5JHEyapryREF1j2xeLhg4WgvCTPCJsDuS/cIFjxCJ9foE2VJEeRXbNp
         fBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=APdJ2bbJpdKbX+Sk+LIMoTdwNG0LJpHDXmC1o7gJlEs=;
        b=mhnmJADckOnNsYTCTolI9l17F9b6AdBK3okUtCrUP7Y/5U07KSYOhzXySuPoQMNvEf
         78a0P/0XRZX9mAXkmciD2N7pauQWHtZ2JeL2tLempvJjS4iZSUbiZIuR13R9Da2rWcfo
         o3c34uhJAKxEKQoYq80MsrHdQkt7rH3ulMB/pFAAizOMATckCJFLYErICrMLN6Vithn+
         C592B8wSt50rTJJ2ajvRdBpoh+crXn0Su6NY424L3TocO+GS/sTRPSjIWngncewZAJpi
         7oTSEMNOobeFJzvsq1IiQ1VNydFPFKpuSaK+K/p3z+PfcJ2grc8VdKNb4H46/IqZBE5u
         6Cig==
X-Gm-Message-State: AGi0PubI+vLUAiOiVz+djDH2aS+n36TeIFGHhwrTICQ/1LMLpa/QlHJO
        C5nTx52vbqXdPT7K3IoswWWVXw==
X-Google-Smtp-Source: APiQypIo2Aco3bI5Gz4obU/4cINPuKZSt8IQago27JXTS7utPnzZj8oW9fEgGAHRnl7DNBznTHSsUg==
X-Received: by 2002:a63:9a1a:: with SMTP id o26mr13288335pge.447.1586216035546;
        Mon, 06 Apr 2020 16:33:55 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:7d7c:3a38:f0f8:3951? ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id r189sm11918932pgr.31.2020.04.06.16.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 16:33:54 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove redundant variable pointer nxt and
 io_wq_assign_next call
To:     Colin King <colin.king@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200406225439.654486-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <434016cd-bf33-ce65-a86b-69a565d62a61@kernel.dk>
Date:   Mon, 6 Apr 2020 16:33:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200406225439.654486-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/6/20 3:54 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> An earlier commit "io_uring: remove @nxt from handlers" removed the
> setting of pointer nxt and now it is always null, hence the non-null
> check and call to io_wq_assign_next is redundant and can be removed.

Thanks, applied.

-- 
Jens Axboe

