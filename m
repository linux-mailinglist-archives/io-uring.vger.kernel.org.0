Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF61A250E
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgDHPYQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:24:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36263 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgDHPYP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:24:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id n10so2550493pff.3
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/dpZO7xGBn/R7cMPlsx5BPFls5g6dIIF5JWr/+x1QeE=;
        b=WEIjPDfMOZfjnkoh83zQiLIsMoJPMUHWCnPPRRF3ek0AfRpL0+Y9DJqB4tZYgPxSO3
         4U6FSgeYUjq+SxnRFuiWYprQ8ENMkkG+nxOKefg5KR3kH2LBTqLfws1VaSocZ3G7Cz97
         O8Rpm+aiDPLSpXEMOdd1dK/lUFzeyPfl+VLIlMOeYu2RUqSvi1QC8uGZKmpLFuWoFt5t
         3ThhyKn3zelE89OwBBg6potJiLx27URQc7mewIigHbxvxECXj8a97nR0nqPVtGzWs1i9
         v8PhgDZl7N1jgb9kuab9bBwyuuoFRRZ2RzHNaZeuQK5nEZXgT1diKfn5yw9wsyzDyzph
         JKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/dpZO7xGBn/R7cMPlsx5BPFls5g6dIIF5JWr/+x1QeE=;
        b=ZA2D4hIW5RC82irluL2R59Mr/KII+BDKiUJ8i5KpQQlmbuWtYTNR9PGfVWd93FKX2O
         7B2s46hNUSptIQAXsKgJHc2/Bp1+DZ2fzlfPQ3sOyoDEzWaX4ceUrabxn5lb+fxPL4FI
         wFqJIh9jFgQofKlGYtTn1NIcQEu+SXQqOVSsDzHeQ9VcKGwypkYiaQxUEDHa2sV7vjGC
         YrhklQ3aNrKhAIc/fC0YX1CWFt0+0YcoHopvKLnUvw4JjimBPQHGIgtlbmfVX935+Ubs
         XbbLvosP+ZO4MtfvEdgbwmLySvP/7m0HeXxwgQTKfUylWEPo1cGcx5zceo1U6u1Qz8D8
         NhCg==
X-Gm-Message-State: AGi0PuZ4+hmOzsko83ladbr5Ycp11EirHpkm3eIF8DnHn5vCLfPSW7Ae
        y2SNk/76jx3vpWDOVPYWqtr7Qw==
X-Google-Smtp-Source: APiQypLfXibFv6lRNTHotlVsXeN8s1ZiNYdCOdKO0UofCtt/3DVIls9UcGXfhwf7nQhqu0r0Z2p/jg==
X-Received: by 2002:a62:ce46:: with SMTP id y67mr6687911pfg.57.1586359454275;
        Wed, 08 Apr 2020 08:24:14 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4466:6b33:f85b:7770? ([2605:e000:100e:8c61:4466:6b33:f85b:7770])
        by smtp.gmail.com with ESMTPSA id a75sm4510652pje.31.2020.04.08.08.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:24:13 -0700 (PDT)
Subject: Re: [PATCH] io_uring: do not always copy iovec in io_req_map_rw()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200408142958.17240-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fa4300a1-861a-5fbe-28b5-8dc5a54f4fb0@kernel.dk>
Date:   Wed, 8 Apr 2020 08:24:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200408142958.17240-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 7:29 AM, Xiaoguang Wang wrote:
> In io_read_prep() or io_write_prep(), io_req_map_rw() takes
> struct io_async_rw's fast_iov as argument to call io_import_iovec(),
> and if io_import_iovec() uses struct io_async_rw's fast_iov as
> valid iovec array, later indeed io_req_map_rw() does not need
> to do the memcpy operation, because they are same pointers.

Applied, thanks.

-- 
Jens Axboe

