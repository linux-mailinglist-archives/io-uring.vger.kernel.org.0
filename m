Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7F6CACF3
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 20:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjC0SXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 14:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjC0SXi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 14:23:38 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8D3AA8
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 11:23:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id r4so5064214ilt.8
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679941406; x=1682533406;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pOqrb4VJ1GMDdhFN7lvr8ImUEPXb5Iv0Fq7oS/oc+Is=;
        b=uz15NpIrAgB/Wy4g6wTbakkr42xsmNGay8uajT52e20mmAGAhKaA8EjqzLlBo3tB0r
         02fpGHo2+AXM+HsSSj9bueoO0sG6vThnqt54UCPwqqBLy/wuwg7UR2yzHwx06qbSCOSn
         SxJyrvSniGMEymS0uVRlFkUKiom9XytzsK29j/cQd1vh7DN/NDWlvjdknrcPRT+jZWlE
         LwQXG2q2gVijs4/nCHVDy/iZRKvccVdi7/6gWKBKnunxV3fem3HnQ/w+e4gMMQXoleo2
         6BuHZqTXXO4hw/M4T6FA2L7qfNwqow9LVgdC3XE+O8yM9RSLU0BbfmuUjB5IJmSWrslc
         MaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679941406; x=1682533406;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOqrb4VJ1GMDdhFN7lvr8ImUEPXb5Iv0Fq7oS/oc+Is=;
        b=FUwL6fULLz74mnvYJCxAiEtd5DvELlpwQjWfZ7FSWu+uYzdp1qUwwto4qWDGVqUled
         9f1FGeKiRI+Y/f8pL7oqr+AdFKLCvByRjKY0OfDuKF0klWjzTjB2EsjKUa5VoQfZiWaK
         dai8Eefrp3gwvLJH54cNYHdnZaqFILDgZQpZbQwh3p5ENLZkJtfqkM7Ot4lnCeC5LI1L
         fWUPumVMSBfxb6SfcyyJULCKgoRkwyLvCE3cPuKlGMvc3rqgvkxXxqmYTRZ75BVSrnTd
         5dNhqpirKFxc8EmW5I5uaZEdrcV/D4EVMtQmlAbo+le/wpxiqYUs4OTHL1dZFngN/zb1
         ICUw==
X-Gm-Message-State: AAQBX9fvFD9kSxVC1ri3cH2CJWZszW9K97GaRsRiv2iE+UBP7TZ2brDt
        AtB7CWwXZpCK6UkCIe/W+zm2yjWbeRw3yMFpznzIwg==
X-Google-Smtp-Source: AKy350b1lzWJq9ib6960aSgopcoJ8OXSaEADi/LjD2n1aJl9x/idILhG0k7Pi+R8KOk+4LCjgsvb8w==
X-Received: by 2002:a05:6e02:2207:b0:313:fb1b:2f86 with SMTP id j7-20020a056e02220700b00313fb1b2f86mr8862932ilf.0.1679941406039;
        Mon, 27 Mar 2023 11:23:26 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id co17-20020a0566383e1100b0040894c572basm4792225jab.125.2023.03.27.11.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 11:23:25 -0700 (PDT)
Message-ID: <2309ca53-a126-881f-1ffa-4f5415a32173@kernel.dk>
Date:   Mon, 27 Mar 2023 12:23:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] Monthly io-uring report
Content-Language: en-US
To:     syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000bb028805f7dfab35@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000bb028805f7dfab35@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 5:01?AM, syzbot wrote:
> 1873    Yes   WARNING in split_huge_page_to_list (2)
>               https://syzkaller.appspot.com/bug?extid=07a218429c8d19b1fb25
> 38      Yes   KASAN: use-after-free Read in nfc_llcp_find_local
>               https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40

These two are not io_uring. Particularly for the latter, I think syzbot
has a tendency to guess it's io_uring if any kind of task_work is
involved. That means anything off fput ends up in that bucket. Can we
get that improved please?

-- 
Jens Axboe

