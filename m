Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65197538D1B
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 10:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiEaIpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 04:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244958AbiEaIpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 04:45:08 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2BC8B0B8
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:45:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t13so17663780wrg.9
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/soQX7cHnl5XSUE5+d9yllfat2BblKyTnOMUTVdeXJ8=;
        b=cVTpXzFeNKwIU2APW6nE3zAk2am+rmChC4nFgSpQJd8KEnBDtUL9zDCDMTJs6JUovG
         zuXt0h5SJ2XgSvbd3/Jclq7pF1HFpKFaD59UjHjeavLp7cxAPLRbddByosb4brOI/aNT
         mKuIy5bn/zewUzH3+Gc1b0uqvUCc1bNgt3tMJukDJVNH4lapzr14cH5CeZW3A/XLXqjR
         SgHGv1GFycnNlHDVt9kXhEGqtfGceNcWW6u7raLQ98tsf+Hpi6WMsxe9OEri07P3mrLk
         NVOgsYmHOozbkEKH/0jVDfhlyKjRKXo33dpvy+/Qbr+TxCKdZS+M3khLhOuaGH5Gy32h
         b+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/soQX7cHnl5XSUE5+d9yllfat2BblKyTnOMUTVdeXJ8=;
        b=uj88dYbeEv2t7ZbD5B/4JHO8Pg+HOu9DGXWuMX1/WGnNnZA/5L+/yK33vykPxQhzHn
         Rc+6293301eaR2JtGy/BHcJwSfqeUDsy7eDewtID+EneghNW/QnefSX8PQ0A9Fh5CJH8
         T9VOHE3ZGzql5P/QpCcEB5AYrm5Y8VCeTAToY9da4TNqoxwPAxFUJiP0NgxqTVtKoxjY
         v8csz0sKeA3FeqwdiLD8Vh73lO/KHV7hrDJvIxUWN4MY9q3tVLqBk9c9z455p1VA+kYG
         UPPTeo4RCp0ts1AXz37dqhF3qNDvFi68dqUePIEBCF3GJkkYhg57zI+r5xEfYZC4IE4d
         efoA==
X-Gm-Message-State: AOAM533nK1JkdS9jLXeiQ+tn6DKxJptG9E/mK/eN3JNvksU5qDG4t90Y
        6wgC0Vdm8mDnuAHz/2W1eKvxzA==
X-Google-Smtp-Source: ABdhPJwiWzJyxo/ze8C7NGWY9vQThUxotc53evucPB2F/Sz4ZoZc7yO/z/VH9oDIhZKAXjskijrpeA==
X-Received: by 2002:a5d:6c64:0:b0:20f:f413:8af8 with SMTP id r4-20020a5d6c64000000b0020ff4138af8mr27888592wrz.129.1653986705746;
        Tue, 31 May 2022 01:45:05 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id e15-20020adfe38f000000b00210326c4a90sm5291477wrm.49.2022.05.31.01.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 01:45:05 -0700 (PDT)
Message-ID: <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
Date:   Tue, 31 May 2022 02:45:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
Content-Language: en-US
To:     syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0b26205e04a183b@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000f0b26205e04a183b@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 1:55 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
> dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
> 
> ================================================================================
> ================================================================================
> UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
> index 75 is out of range for type 'io_op_def [47]'

'def' is just set here, it's not actually used after 'opcode' has been
verified.

-- 
Jens Axboe

