Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88176BD445
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCPPrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjCPPqz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:46:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2EA11E9A
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:46:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x13so9465177edd.1
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678981528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nRiSHzD6wnbLebf5HlzqseAV6jx8ROZn0n1HS9ZDHos=;
        b=MS5S7mYP9HzxRNPMrVPpsg4sl4edYa9Ld7IAWLRPtba1yUhgsWukANDqriDgvzTS4N
         8s8bUVjmaYKnJNPI/y4Nc9WSYtuTTQVuqBAk+gUJiFGffIVVyu1rslSgSeJoSStwkMFx
         4cfrhUFGvnIz9KqPVUoEDbGhDFP2ZThc63gBsgfT5cYRKAJMPwmTP1lBHiI+NUsZXg+S
         pw4r9zqa47aliMzSk1/SkNqLswFHeQT9y/X9QUu7MjaKqGv8fPN7a2V7VvvsFcY20T9T
         E91yWnlGIc/EpsE03dZGwx5epFva7JBiimupsQRA1+q6zZMJBIE5mvKjj+3j1KkmoRvd
         xAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678981528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRiSHzD6wnbLebf5HlzqseAV6jx8ROZn0n1HS9ZDHos=;
        b=EsrtyNWlf6ZjaZk08h4+3wj9sZXSePE4vbQiArmLL8md6QQnAjVpF/ykED2pjfCKF4
         3BfybL4WAkgCbPeT4LMyQW/jsJP6FKv1L4vusiifNci8+s41GDC+E6UqnlkAjB1m01Or
         ZqDOTnNvqGpkidmWtp5U1cX+xebYEY1LwS8F98VR0aHJeCnbcPi/qN6FuO59FR9iuo6h
         l8b1BOzFZQkDu1ak26AEsz/uzaDyEmknXlfK/U7vJ19WJWL//7TtppmfIJQ19H3iVNLD
         S6S+JvQyWEFoFe/9RlXhofNjCvBFYrsCY9LnGyaf/+MEoq78Hj6iLxBT8EVFl+pDvep+
         cA5w==
X-Gm-Message-State: AO0yUKX0ZT+AaiMlErXQrrIHOVwAz3FldcDDXK36S3gW1GSnpUO+NFLo
        OEhyU9pY7VB1GoNBZwKwc8ocKsR9tSo=
X-Google-Smtp-Source: AK7set+znDyvyLtBxPAMFenZTex4987Z6uGv2uL9EXNx4wwquMvyyz1eqv3YNeo+F1GUiLH1v0mEJQ==
X-Received: by 2002:a17:907:60d3:b0:92a:3b19:9a4c with SMTP id hv19-20020a17090760d300b0092a3b199a4cmr3903911ejc.27.1678980851628;
        Thu, 16 Mar 2023 08:34:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id v30-20020a50d59e000000b004af7191fe35sm4024614edi.22.2023.03.16.08.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 08:34:11 -0700 (PDT)
Message-ID: <a0c0bbdb-81f3-fb20-a643-a6582b6fc5c4@gmail.com>
Date:   Thu, 16 Mar 2023 15:33:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/1] io_uring/rsrc: fix folly accounting
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>
References: <10efd5507d6d1f05ea0f3c601830e08767e189bd.1678980230.git.asml.silence@gmail.com>
 <167898075271.29101.7596458728573428968.b4-ty@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <167898075271.29101.7596458728573428968.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 15:32, Jens Axboe wrote:

As Jens rightfully noticed, I screwed the subj
s/folly/folio/


> On Thu, 16 Mar 2023 15:26:05 +0000, Pavel Begunkov wrote:
>> | BUG: Bad page state in process kworker/u8:0  pfn:5c001
>> | page:00000000bfda61c8 refcount:0 mapcount:0 mapping:0000000000000000 index:0x20001 pfn:0x5c001
>> | head:0000000011409842 order:9 entire_mapcount:0 nr_pages_mapped:0 pincount:1
>> | anon flags: 0x3fffc00000b0004(uptodate|head|mappedtodisk|swapbacked|node=0|zone=0|lastcpupid=0xffff)
>> | raw: 03fffc0000000000 fffffc0000700001 ffffffff00700903 0000000100000000
>> | raw: 0000000000000200 0000000000000000 00000000ffffffff 0000000000000000
>> | head: 03fffc00000b0004 dead000000000100 dead000000000122 ffff00000a809dc1
>> | head: 0000000000020000 0000000000000000 00000000ffffffff 0000000000000000
>> | page dumped because: nonzero pincount
>> | CPU: 3 PID: 9 Comm: kworker/u8:0 Not tainted 6.3.0-rc2-00001-gc6811bf0cd87 #1
>> | Hardware name: linux,dummy-virt (DT)
>> | Workqueue: events_unbound io_ring_exit_work
>> | Call trace:
>> |  dump_backtrace+0x13c/0x208
>> |  show_stack+0x34/0x58
>> |  dump_stack_lvl+0x150/0x1a8
>> |  dump_stack+0x20/0x30
>> |  bad_page+0xec/0x238
>> |  free_tail_pages_check+0x280/0x350
>> |  free_pcp_prepare+0x60c/0x830
>> |  free_unref_page+0x50/0x498
>> |  free_compound_page+0xcc/0x100
>> |  free_transhuge_page+0x1f0/0x2b8
>> |  destroy_large_folio+0x80/0xc8
>> |  __folio_put+0xc4/0xf8
>> |  gup_put_folio+0xd0/0x250
>> |  unpin_user_page+0xcc/0x128
>> |  io_buffer_unmap+0xec/0x2c0
>> |  __io_sqe_buffers_unregister+0xa4/0x1e0
>> |  io_ring_exit_work+0x68c/0x1188
>> |  process_one_work+0x91c/0x1a58
>> |  worker_thread+0x48c/0xe30
>> |  kthread+0x278/0x2f0
>> |  ret_from_fork+0x10/0x20
>>
>> [...]


> 
> Applied, thanks!
> 
> [1/1] io_uring/rsrc: fix folly accounting
>        commit: d2acf789088bb562cea342b6a24e646df4d47839
> 
> Best regards,

-- 
Pavel Begunkov
