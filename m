Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500BF70566C
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 20:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjEPSzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 14:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEPSza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 14:55:30 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB3FAD18;
        Tue, 16 May 2023 11:55:23 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30639daee76so9525960f8f.1;
        Tue, 16 May 2023 11:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684263322; x=1686855322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/xFBsvb/OmCCah1ervhaf7jtZcL9dzbDGbW/YObJ+w=;
        b=TW91y52ZVwjY8tlkfIIxvwq0KmwqktfLJToouLS4RMuywVhMqBgnjKs9L5sfBn/Y5I
         jB08wzqMbyng4yYhE2+1AmBeXe+JUFQ92Zdaayd2+LbsgwdqBXbjucnhI6nymiE2ZXit
         6lBNOROF5+rf4oOLeYnsagnfuc5a8hU318i7CoFWf6zXEejbu2951sGSHwAAP4H0p3XD
         5iRzIcI3edhLgLNEPfDyP3yWHjOeslhbIQ1+fzGnL3jKygUL3DIgGFRzt/lbmd5BF+Hf
         d92vXmV/dbaWK6lE6tv0usKf2wDUZwDt1mDr+Xd6Rx7lT8rEWWw30EXPqDWAzH2K6dVH
         Y5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684263322; x=1686855322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/xFBsvb/OmCCah1ervhaf7jtZcL9dzbDGbW/YObJ+w=;
        b=V3uJQbYu1SfMocyn+IUcKPee+el2pPOy6lSADJbbFoOrV8c7qXaoEs4KqhvKR8Qz1E
         PFMO+kF0hRcKA9YWDoHBW/KlzGrbwtB9hBiv33NchbX8l9LvEVMEMC+JFSpX80mHb1vT
         RZiGY4rYmpjpwxdIiLlSnnsHTy9QzrBZMldnTRGfOKq4YxDrHHtlIngDeEhkNE5mC6qK
         LpeIQKS1X4EAO4XbYJhcokzUrmSRDxGn1r1HTRRFL+k41RPB9oK9nzyMykdpMpIYG2bh
         upfQ3FqTp9ipL3czfT5tvP3XpKJIrZr1ees0dT10At9HAjQVxcfsvFcETDT+q882ztf4
         WYew==
X-Gm-Message-State: AC+VfDyviwJsR1BdzuBMEGHm7OUoNwxRsvJIgizCp1+kyUMBreb1QKDA
        KD+3DNWd3O2AT1wfgRz6vBs=
X-Google-Smtp-Source: ACHHUZ7sm7xU7fDLQ3R+lIEMorQEICVDfIudZPUw/GTQxcWISWjmjbvVnCjx1Z4gKznOYHgf/4k4tQ==
X-Received: by 2002:adf:f291:0:b0:306:3bf0:f1ec with SMTP id k17-20020adff291000000b003063bf0f1ecmr28940733wro.7.1684263322254;
        Tue, 16 May 2023 11:55:22 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.10])
        by smtp.gmail.com with ESMTPSA id z3-20020a5d6543000000b002fda1b12a0bsm267785wrv.2.2023.05.16.11.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 11:55:22 -0700 (PDT)
Message-ID: <65514f94-ac70-08df-a866-fe73f95037fd@gmail.com>
Date:   Tue, 16 May 2023 19:52:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 1/2] io_uring/cmd: add cmd lazy tw wake helper
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me
References: <cover.1684154817.git.asml.silence@gmail.com>
 <CGME20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a@epcas5p3.samsung.com>
 <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
 <20230516100000.GA26860@green245>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230516100000.GA26860@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/23 11:00, Kanchan Joshi wrote:
> On Mon, May 15, 2023 at 01:54:42PM +0100, Pavel Begunkov wrote:
>> We want to use IOU_F_TWQ_LAZY_WAKE in commands. First, introduce a new
>> cmd tw helper accepting TWQ flags, and then add
>> io_uring_cmd_do_in_task_laz() that will pass IOU_F_TWQ_LAZY_WAKE and
>> imply the "lazy" semantics, i.e. it posts no more than 1 CQE and
>> delaying execution of this tw should not prevent forward progress.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> include/linux/io_uring.h | 18 ++++++++++++++++--
>> io_uring/uring_cmd.c     | 16 ++++++++++++----
>> 2 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>> index 7fe31b2cd02f..bb9c666bd584 100644
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>> @@ -46,13 +46,23 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>                   struct iov_iter *iter, void *ioucmd);
>> void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
>>             unsigned issue_flags);
>> -void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> -            void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>> struct sock *io_uring_get_socket(struct file *file);
>> void __io_uring_cancel(bool cancel_all);
>> void __io_uring_free(struct task_struct *tsk);
>> void io_uring_unreg_ringfd(void);
>> const char *io_uring_get_opcode(u8 opcode);
>> +void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>> +                void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>> +                unsigned flags);
>> +/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
> 
> Should this also translate to some warn_on anywhere?

Would love to but don't see how. We can only check it doesn't
produce more than 1 CQE, but that would need

nr_cqes_before = cqes_ready();
tw_item->run();
WARN_ON(cqes_ready() >= nr_cqes_before + 1);

but that's just too ugly


>> +void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>> +
>> +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>> +}
>>
>> static inline void io_uring_files_cancel(void)
>> {
>> @@ -85,6 +95,10 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>             void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> {
>> }
>> +static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +}
>> static inline struct sock *io_uring_get_socket(struct file *file)
>> {
>>     return NULL;
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 5e32db48696d..476c7877ce58 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -20,16 +20,24 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>     ioucmd->task_work_cb(ioucmd, issue_flags);
>> }
>>
>> -void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> -            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>> +            unsigned flags)
>> {
>>     struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>
>>     ioucmd->task_work_cb = task_work_cb;
>>     req->io_task_work.func = io_uring_cmd_work;
>> -    io_req_task_work_add(req);
>> +    __io_req_task_work_add(req, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);

--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h

+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+}

That should fail for nvme unless exported.

> Any reason to export this? No one is using this at the moment.
>> +void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
>> }
>> -EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>> +EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
> 
> Seems you did not want callers to pass the the new flag (LAZY_WAKE) and
> therefore this helper.

Yep, I wouldn't mind exposing just *LAZY_WAKE but don't want
to let it use whatever flags there might be in the future.

Initially I wanted to just make io_uring_cmd_complete_in_task and
io_uring_cmd_do_in_task_lazy static inline, but that would need
some code shuffling to make it clean.

> And if you did not want callers to know about this flag (internal
> details of io_uring), it would be better to have two exported helpers
> io_uring_cmd_do_in_task_lazy() and io_uring_cmd_complete_in_task().
> Both will use the internal helper __io_uring_cmd_do_in_task with
> different flag.

That's how it should be in this patch

-- 
Pavel Begunkov
