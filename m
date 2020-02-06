Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F28154C74
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFTwV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:52:21 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39975 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgBFTwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:52:21 -0500
Received: by mail-il1-f194.google.com with SMTP id i7so6243105ilr.7
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/GI0x8aCVNKIMLzA3XY2pv1luDDrx3P+zazrMcLhILc=;
        b=OEQQuP4ZmetlqILLWOGkdeW5LVUmoD2ikmnLCT1X+EvodvWW8eeb1akQEhgIKZJVJV
         sp16BDvSLgPWbMFMhSiAxLzN1xe5Zo9EpTZ2mD4VNz2Xq+2KAhZAHhk3JY2O2ug8313J
         /tvj7MMynUKOSwdvMIWpjIiCK3NeoLNuWVB07VPlalJMJdiJlFEcVk+lxzzFk23MbEqg
         xXkJAW0m0Jrg0yhDjLwOpURuKPw/1PKMzJkh+bc2JEwYLsRkM9Z5TUhJe/to21lcSXuR
         enAoATaO4KHp4ek6aiqzSRAMpMANDVyTbZAuSFqJ3lMTkkp2IvdhvF8hOQrRCPgoEbR1
         QxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/GI0x8aCVNKIMLzA3XY2pv1luDDrx3P+zazrMcLhILc=;
        b=LkUgofWiCX0U3k+mcji+dzgokQBHp6TOlp61lLfcaL/D2FNEL1MywXfxTDIemstwlp
         7Bmt8cL0VL2yvB3gMK+GSj9mK0YOwsXYkr3uHCdKq25arFJckrUsAaJNpM6frCU3DtB5
         fV8+C0LlkgzR8JiPQjJhRLmsY2ukf+xumiNtfC659bC6Pt1pikq3EOGlTre004gHCOxi
         M3T3PObojf2+CyAMYHGkpbIKjm8OKxYMPeMCKnym3jO/FJW1UF743R03issY9m+UXyry
         2P6yiLmMoTgo9UHxcTbMgUjLWTQEi2cS+WCaUYWiRIiYYqWPt+f0PouGu6z8QNhIxLcj
         hXsA==
X-Gm-Message-State: APjAAAXvCrnYO3PT27/JThSi+mlaOA9ZLy/Lc4IaNw8hXwyGuwAqjgd4
        E/Z8ESl3AujZ8Det1N2kBqePUQ==
X-Google-Smtp-Source: APXvYqzDdGbbKaFV7gIifpEe7KdoksmmwNedOy6I9rfJNrF9Dy/F0iM/VqsFZM5eEL5iOyV8EjSzQw==
X-Received: by 2002:a92:5acd:: with SMTP id b74mr5654184ilg.240.1581018738798;
        Thu, 06 Feb 2020 11:52:18 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm274230ilk.4.2020.02.06.11.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:52:18 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix delayed mm check
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5c7db203bb5aa23c22f16925ac00d50bdbe406e0.1581012158.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8dbd13cd-6e93-b765-ade2-27ba91d8c30d@kernel.dk>
Date:   Thu, 6 Feb 2020 12:52:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5c7db203bb5aa23c22f16925ac00d50bdbe406e0.1581012158.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 11:16 AM, Pavel Begunkov wrote:
> Fail fast if can't grab mm, so past that requests always have an mm
> when required. This fixes not checking mm fault for
> IORING_OP_{READ,WRITE}, as well allows to remove req->has_user
> altogether.

Looks fine, except that first hunk that I can just delete.

-- 
Jens Axboe

