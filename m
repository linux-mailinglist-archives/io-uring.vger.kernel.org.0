Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605DF446CD7
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 08:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhKFHPa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Nov 2021 03:15:30 -0400
Received: from [103.31.38.59] ([103.31.38.59]:52192 "EHLO gnuweeb.org"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S233612AbhKFHPa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 6 Nov 2021 03:15:30 -0400
Received: from [192.168.43.248] (unknown [182.2.38.101])
        by gnuweeb.org (Postfix) with ESMTPSA id D4DC9BFC2C;
        Sat,  6 Nov 2021 07:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1636182767;
        bh=7H28ORP1QiFj2B2Z153JaJMaxh7DrB6hvJmL8uGJiVI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GpdOSjQfeiN7dDU79QFNfTft68VknmZ+hadnfn86oEkTIPy4FKSQNqOHZ5Gx8HN1w
         9jVSEexb/FKhDPBWeGBLhzpi1UHxEoTPwhe8t2SzhMwe4/XI041FY7YgmQxyUHaGzv
         wF8wtzUjsaQBZWYY44l5GKsoMoj0Dy+gqLwx1kpZv/dJOecEgOq91iJCicD2Ew1CP6
         sUeHN/BvVv0Fd9VZvkpnF38LXv4IbmWJ6TV5KIfkP7AQ54kMnB+Zfl9rg+Dcqzo2y5
         HpH+Y8MeZOCin88rVsButONFu8UHTmuoEZM0ZeyRLPyAYA9wzGhZvt4f7PC1dYFMaD
         oUwI9yvbHP70Q==
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Drew DeVault <sir@cmpwn.com>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Message-ID: <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
Date:   Sat, 6 Nov 2021 14:12:45 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/6/21 2:05 PM, Drew DeVault wrote:
> Should I send a v2 or is this email sufficient:
> 
> Signed-off-by: Drew DeVault <sir@cmpwn.com>

Oops, I missed akpm from the CC list. Added Andrew.

Cc: Andrew Morton <akpm@linux-foundation.org>
Ref: https://lore.kernel.org/io-uring/CFII8LNSW5XH.3OTIVFYX8P65Y@taiga/

-- 
Ammar Faizi
