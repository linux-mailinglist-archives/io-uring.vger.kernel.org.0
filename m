Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE13EDD52
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhHPSuH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhHPStj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 14:49:39 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E71BC061796
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 11:49:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c4so5532026plh.7
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zrQFr/RZT5r7P0EMq4YVrA6Z4YZwFltYDgB4dpOQ0F4=;
        b=aBcZXWqP3l5r+lXxmb+HVrsFGqzg9n8j1239vzJCKTPZzdDntE6jIBwQT5Mgrg3+p8
         kD3kDWxTJ2O2veMLwEWybKSu5F9+Z0LybWEK1Ad/Bp+9d5Nhh+L3t8tjz/oLzjvKvsgE
         mU4CJ2ICubj3ALe+pGsuNvCGo6B9YseOAMZskrsrGDUIpGdpCUwqqftu6RfHx1WP+0kb
         MQGA9InOGsnmFSAbpHbGwZeygAVTqW2NZEyHMJebP1LJty+55Mt9d70BdTSXk96v0S9A
         CcIumzwtPCnvKhO6brOB+SyuCmBE5vyJVukRlBZy8rf20+YI2uQLpsMK6rbWvkjC1My4
         K32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zrQFr/RZT5r7P0EMq4YVrA6Z4YZwFltYDgB4dpOQ0F4=;
        b=OI19gOqqyWDvrElIDsWWU0S/12fN5upKImI/i9xbsNa5jMp3qm6X6jqObeXUNWav9f
         8Z458Sjd0R1ZYwqI7pzrnBmhbHzdlMTRPvR8GGQLMhL8mW3b72DzYirFGN9RUudRb1aR
         QmLoBeT8qGiYryHDymYjFtGeS1fxmjiXMu7rU5KN1Bid5Wnwne2/SxqV/g3vx4aMsolR
         wGWl+dKFJ/0Ogqxm9znyU5Be8yxcKOkBkLRd1vsO+So9ifKOKC5TBiee8SYu16HjPGUp
         AhTPwCXvxCYyJzskTc46DEKvcfBdGPHE0qh3dcQYbvHUK0ok/jkonqY6vl1WiN9ROac0
         /CKw==
X-Gm-Message-State: AOAM530/EVL5RHotmaygeVBx9imXBRPVG4Tp7qt7O8mzqAlaUKhw/W2M
        1p9QONX6JI00aLr4dQorQ8dUCg==
X-Google-Smtp-Source: ABdhPJysWBwZz5Hg2fi7bW4RgW0rL0mGmPF0wiUQ8P3CVVv8qYSpYCM6Oer4yenrObBUGIx4HKfoag==
X-Received: by 2002:a17:90a:db09:: with SMTP id g9mr42900pjv.205.1629139747490;
        Mon, 16 Aug 2021 11:49:07 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v1sm122166pfn.93.2021.08.16.11.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 11:49:07 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: don't forget to clear REQ_F_ARM_LTIMEOUT
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com
References: <614f650abdd5fee97aa5a6a87028a2c47d2a6c94.1629137586.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <16575c24-51d9-0946-4a89-d4320b51d79b@kernel.dk>
Date:   Mon, 16 Aug 2021 12:49:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <614f650abdd5fee97aa5a6a87028a2c47d2a6c94.1629137586.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 12:16 PM, Pavel Begunkov wrote:
> Even though it should be safe to poke into req->link after
> io_issue_sqe() in terms of races, it may end up retiring a request, e.g.
> when someone calls io_req_complete(). It'll be placed into an internal
> request cache, so the memory would be valid with other guarantees, but
> the request will be actually dismantled and with requests linked removed
> and enqueued.
> 
> Hence, don't forget to remove REQ_F_ARM_LTIMEOUT after a linked timeout
> got disarmed, otherwise following io_prep_linked_timeout() will expect
> req->link to be not-zero and so fault.

Since its tip of tree, I will just fold this one in.

-- 
Jens Axboe

