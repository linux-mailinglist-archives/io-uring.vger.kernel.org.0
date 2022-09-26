Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ABB5E9E95
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiIZKGF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 06:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiIZKGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 06:06:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CB73719D;
        Mon, 26 Sep 2022 03:06:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n12so9372055wrx.9;
        Mon, 26 Sep 2022 03:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=RMivvzdJImEjzPUG1xZSPrb1sw7OyHM+Raq97VRxsCA=;
        b=X3Y2zEGlEdX2dReB7gHnUjEzNL04KOKJuH4vCtJeA5w2XdnRJitoAAVgOota75m3jY
         JUk1jJxzOCBqVvA/U900zVK712ziT7DQKRD5XeXNJZMfOQDLDpxCz07rAcsOBNVzyuM6
         FQbUYasbpX/PZKfEoQkdatiEjwXvkOoflouoGVhXVotR7ljGE5SomXU44kt74+iAjEXN
         lt0cmMHhQpoOxSUhyulZ5bRAyvowstIGUEyyba6bQ2jj+P0mwi6Cc/vdrLbpYqzBpMzI
         L30Q623PxQvZ6GC/YXVUHSRvEoizLuF6Ia2AcL1HTgkdHgD0jAnhgIN3zYXpBineAsE0
         cdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RMivvzdJImEjzPUG1xZSPrb1sw7OyHM+Raq97VRxsCA=;
        b=ZcxtnKqAkkmvCUzcMjWJubDhLhXb33eZz+a/BltI6958IB5MtaS8p9u6ON7AB4jKlP
         DXoAF3DRgkI+jrCztcKHmc8qO+onupy+BYpaorE3WeAFeMG5wdRVYPHJFt1e4deDm4yu
         DzaQd2jHuLJQ821CDH+YHpzuKrIEaVerB9Qi9me9A1xd+PIZ/PcL/n9fW4XVCpiGGY0v
         DdpsxMRTg4rtioGRXMgWYSDlV7mUGGx6NAIwYtLbOdeNptUhOJUllseq675NJJIxtgem
         OG7gV5ahcJvym/o+62yMaHjbbzz2IBlnq/ERtVRvxccBfOYG0C7PnomicmPDU2vVYEZg
         pikw==
X-Gm-Message-State: ACrzQf1pnDXkjdGcvPYFrV0b+6JNRgzYexBwywhHI+qJoNfuXafDXa54
        nEF3uRQ5pAgDuPoQxUV/BgYWYWzaQwk=
X-Google-Smtp-Source: AMsMyM4QXhFQKm3afaR2/+o31hmb62Q9BLZQ1xN2DBx1CAGV42FHBOxw2nX2DfegbQlQLWKV3inDBw==
X-Received: by 2002:a5d:65ce:0:b0:228:d8b6:d1 with SMTP id e14-20020a5d65ce000000b00228d8b600d1mr12928071wrw.486.1664186759884;
        Mon, 26 Sep 2022 03:05:59 -0700 (PDT)
Received: from [192.168.8.198] (94.196.6.209.threembb.co.uk. [94.196.6.209])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6405000000b0022af9555669sm16251734wru.99.2022.09.26.03.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 03:05:59 -0700 (PDT)
Message-ID: <cba736c2-2e5b-e433-2334-4e96624a8d5f@gmail.com>
Date:   Mon, 26 Sep 2022 11:04:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [syzbot] KASAN: invalid-free in io_clean_op
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     syzbot <syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000091b65005e983c19d@google.com>
 <8c9845cf-a5fe-21c0-10a5-2369758dd23c@gmail.com>
In-Reply-To: <8c9845cf-a5fe-21c0-10a5-2369758dd23c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/22 18:54, Pavel Begunkov wrote:
> On 9/25/22 18:29, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
>> git tree:       linux-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1608cadf080000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
>> dashboard link: https://syzkaller.appspot.com/bug?extid=edfd15cd4246a3fc615a
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144acdef080000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10686540880000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
> 
> #syz test: git://git.kernel.dk/linux.git for-6.1/io_uring

Should be similar to the previous net/op_clean problem but
now zc and because of that we set CLEANUP too early. Just
a guess, will take a look at the repro

-- 
Pavel Begunkov
