Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56402650CC3
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 14:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiLSNnH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 08:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiLSNnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 08:43:07 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208D5F03C
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 05:43:06 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h16so8622938wrz.12
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 05:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HtrgrLpkHxh8gEPJ4KfcEeRr6pL/NkzA0rDFgq9a9nA=;
        b=VHOK3i3+VNyVM3WzgUZ6NBKpGpCI6oblsVcDjxFUVdTirozTNuTaFcElXPKp74k/jE
         WIYSKHqcgeUIApr+KTjiM1EFUBzh4Jrwdg7M5umLkrOl2NEPMbSMbKgPm0+6Ur6NT9PQ
         +XhmRNIO1Ud84gAbbDmQFf6Lady6NAgBt5I8D7shIOEo2A4eN6toiPBwZ/MaE0Ncq+NC
         eTXocmvDRw0dDxbNewRMdWhFoZIqRhgwW1XjXryRCXJ3jjNVQx4YUx8g5YIVrQrBX2Xz
         8utEqFbZkK/tTMFr/ceEqywS7ktdKUwCt7SlKz3p097VTeoVnKFQ5mfEHDu+7wAHOZw9
         dblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtrgrLpkHxh8gEPJ4KfcEeRr6pL/NkzA0rDFgq9a9nA=;
        b=Hv9SSEn2ZQA7vt8TJ/JgP4MHebiV0F4LgmI/3EIdke0iCDG+DCKxfiGHaZD+BAJ//s
         DfturjrUlQHnCgXWGME5L4i5SOQ+CGghGAh9h2w8qEhkhk1CXNd/Kvvoy0NH1+/zvIKC
         scnrewKUeKeHvVOLI8GkI0uk/yeiE8gDf4M2ldVIdZMm2/4cIvk4ZZO6RtuKc3UlZLuC
         mDukqS4pVel8mbArav+QSjq/D9ef0oeDi7w+7fecXzpoxvqkPMyivag47+kJxWmu87Mp
         86O22gVA8uUTT0kdTsW2ONAvNr3TOtz8kLlflkE0ABKYmsIf9Dc5Hq51rVaQQavoiHUR
         JQHw==
X-Gm-Message-State: ANoB5ple3v4eJ6YFN0GS1rS2b0Kk+vZJqDuU1PBaDgfJPkiDXzOnLJ3p
        UFIl7K3FMyUG/A672+heOKH2LH/ZKNs=
X-Google-Smtp-Source: AA0mqf5yedGWs6nqfD9Bl3xeADEAJUsYjhTRrfjTWl5KTNME7WMN8pLVNR2gSTM7i2LMxiy++hjy3Q==
X-Received: by 2002:a5d:4005:0:b0:244:e704:df2c with SMTP id n5-20020a5d4005000000b00244e704df2cmr24695014wrp.57.1671457384569;
        Mon, 19 Dec 2022 05:43:04 -0800 (PST)
Received: from [192.168.8.100] (188.28.224.246.threembb.co.uk. [188.28.224.246])
        by smtp.gmail.com with ESMTPSA id z15-20020a5d4d0f000000b0023677e1157fsm9907718wrt.56.2022.12.19.05.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 05:43:04 -0800 (PST)
Message-ID: <105573b9-efda-80b1-0a66-b00569e89911@gmail.com>
Date:   Mon, 19 Dec 2022 13:42:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: User-triggerable 6.1 crash [was: io_uring/net: fix cleanup double
 free free_iov init]
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
References: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
 <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
 <032f142f-8439-b2e2-5108-4f41e66e3b0c@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <032f142f-8439-b2e2-5108-4f41e66e3b0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/22 12:32, Jiri Slaby wrote:
> On 19. 12. 22, 11:23, Jiri Slaby wrote:
>> On 26. 09. 22, 15:35, Pavel Begunkov wrote:
>>> Having ->async_data doesn't mean it's initialised and previously we vere
>>> relying on setting F_CLEANUP at the right moment. With zc sendmsg
>>> though, we set F_CLEANUP early in prep when we alloc a notif and so we
>>> may allocate async_data, fail in copy_msg_hdr() leaving
>>> struct io_async_msghdr not initialised correctly but with F_CLEANUP
>>> set, which causes a ->free_iov double free and probably other nastiness.
>>>
>>> Always initialise ->free_iov. Also, now it might point to fast_iov when
>>> fails, so avoid freeing it during cleanups.
>>>
>>> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
>>> Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Hi,
>>
>> it's rather easy to crash 6.1 with this patch now. Compile liburing-2.2/test/send_recvmsg.c with -m32, run it as an ordinary user and see the below WARNING followed by many BUGs.
>>
>> It dies in this kfree() in io_recvmsg():
>>          if (mshot_finished) {
>>                  io_netmsg_recycle(req, issue_flags);
>>                  /* fast path, check for non-NULL to avoid function call */
>>                  if (kmsg->free_iov)
>>                          kfree(kmsg->free_iov);
>>                  req->flags &= ~REQ_F_NEED_CLEANUP;
>>          }
> 
> I am attaching a KASAN report instead:
> 
> BUG: KASAN: invalid-free in __kmem_cache_free (mm/slub.c:3661 mm/slub.c:3674)
> Free of addr ffff8881049ff328 by task send_recvmsg.t/733

Thanks for letting us know, I'll take a look


-- 
Pavel Begunkov
