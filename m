Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134841BAA71
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgD0QwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgD0QwY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 12:52:24 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C958EC0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 09:52:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q10so17360528ile.0
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 09:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AnckgGRaqLjjflBT9BecnXRjs3tLTpJvxkriP73+x4g=;
        b=WAhpvnqyCOvJVwBkYMaUHTPYGFcb1WVyhKzu9x5uw93wk1RWg4rWsrzedBBvonQjGW
         uoIVt0O5+gK+oyZsD7SLlAXhSo4O2L+iJ4JIi50XgZdB0ecXZ6zYPf1j+phqOOHbad3B
         lALw3Uj8AR/0NVGlhrscQH6a6NGyUocVJbgOdo07Unhc+JG2Zv/bfmHp0pnxfhkvJaIE
         WHeYYUhLyEq8BIHQ4dngnNQ7IoSbE4G+JG+CSKW0FV7tjXhLNsu134mSZQUfLPrVK80O
         SQyswHOnolzSp925D8XEwG2kZFUnAJOC4zhUa9Q0hJeVqv6ImV0HWOQQTYW/OBS7x7dT
         5Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AnckgGRaqLjjflBT9BecnXRjs3tLTpJvxkriP73+x4g=;
        b=fHYOMhJXtpu2q9kZiNsZRR7kloWIRkyQEYGXXODhnUrpczrXKUzR8VCuAyVOsgnffk
         hrPYV5DZH9meIU+H1iG9EJNjAsIw35jqPKB7Mwxv38Rx5ilGPv2lNk4q1jMPrZ4J3KFF
         zmPIUAvQuLttWEBJY4FsD6GxQnveJ+Uoy1wtmiXL25uXNg1aGqLhQrSTnXC26qFiAUum
         kl445cV6QOcRWeBfC2pNPPn7lg4UKf4fXJ7zOGEEbfThe97E0XIwq6uhGKiptzrf1OjQ
         p1tYZLMnjWNTcWD2LvtOiunFNe5QJ7kvXOOiYNb3X/PpKSJk9gnBkXDLTM97X4GRknNo
         9Zog==
X-Gm-Message-State: AGi0PualT6mYSDHPtnfv2BnttTusYYWG3xniI3eNOGKClQgk0QqzmsPE
        Lrjige6cnojIqwwVaqa4C52CGl4T4I0jhA==
X-Google-Smtp-Source: APiQypJ2vJ2JK76l2a4t+EAok5indTkD7ZGsx5vyM1jWtSHsUNRJ1By+yWl9pBiC7Vyb/OSc8v5NlQ==
X-Received: by 2002:a05:6e02:60a:: with SMTP id t10mr21888014ils.302.1588006343677;
        Mon, 27 Apr 2020 09:52:23 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k11sm5162210iom.43.2020.04.27.09.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 09:52:23 -0700 (PDT)
Subject: Re: io_uring statx fails with AT_EMPTY_PATH
From:   Jens Axboe <axboe@kernel.dk>
To:     Clay Harris <bugs@claycon.org>, io-uring@vger.kernel.org
References: <20200427152942.zhe6ncun7ijpbffq@ps29521.dreamhostps.com>
 <560ae971-fd9b-4248-cd56-367bde8f903c@kernel.dk>
Message-ID: <8298f71d-b4a1-db76-dc21-24d328a2534d@kernel.dk>
Date:   Mon, 27 Apr 2020 10:52:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <560ae971-fd9b-4248-cd56-367bde8f903c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 10:40 AM, Jens Axboe wrote:
> On 4/27/20 9:29 AM, Clay Harris wrote:
>> Jens Axboe recommended that I post io_uring stuff to this list.
>> So, here goes.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=207453
> 
> The below should fix it.

Added a test case for this to the liburing regression suite as well.

-- 
Jens Axboe

