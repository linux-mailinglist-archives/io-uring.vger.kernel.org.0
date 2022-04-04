Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE924F10D3
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 10:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353036AbiDDIYe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 04:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbiDDIYd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 04:24:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C2A3B3FA
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 01:22:37 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r11-20020a1c440b000000b0038ccb70e239so1577354wma.3
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 01:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W/TzCLb1GbKboGgilj9E1k/qjcATj9ekUppo8Ze2qiw=;
        b=DSQ+JPrUVvx/uljBfq4a3ySV0YwGQR2CfaX8bKkt4ilPDWIZl2a6Fr4Pu3pGtpcd3E
         A36uArXC3WCRu81ta3Y9FjvHgpHx/kbWlipcgiWmsRvZQEA+9tbmjBz+AOpB9ZqMx6Ph
         MDePZAV8nv0aAiIAnMgbUPL+1AFsXez9PX9IjKXZLidsAUKyXCjyGL+O57urnWzyJ3kI
         U+h/Z1+sAILiPmwjLcOwbiSld8mDAW9z19kVm7UXlOezMut85fKinyfpN4QhbN+SPXJr
         54+NpzrqllL7d4K+N+snN0MuFbXyOV22Tx+4iOaWqB+nQf7J+zOGMTqspLziWLzua3e6
         nUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W/TzCLb1GbKboGgilj9E1k/qjcATj9ekUppo8Ze2qiw=;
        b=sCh94NPcw3cbSGfceqCX9Gmr35P8zMcKHu8IfsdP32KeLO/Gs603pCsNxYY6GFsmdB
         +hWitlE9USDi389Bf/kKB1E13sJqP1FvWeJiR6awKVA7xZiPLrvWcpFftYkM72M5O4Q9
         y74rvji6bNMMVkAUnqca9fKulEimrn1efqc1jWRorLKb2pbSocwOAy4tZVyNRXvs89PY
         88eoEgn04oXKXkeIv+H49XLUe1IPGPk3UDqAddjMRzI9CvyVf2VS2dIC/hiKHAc921Y7
         UENEShSfsplwMMZbHp7fqYnn4+mIAKk4vyGnNCzeCoB3BAfYSXe8rfCHcdc9ZjGi03xE
         YmaA==
X-Gm-Message-State: AOAM532hM/PQdm9GbLRtyNAMZNAkQrsbyWyjp1CLyKlsBpu5RA1lKHE/
        K/oTxPVcpqNTQFHMLBUB/+Q=
X-Google-Smtp-Source: ABdhPJyPPsUg30vlh380C1VLD1PdXGROirLq+VRfWjp4JqalVyZVsSAY/uq8OLk+I4JWx+Kt71cYjg==
X-Received: by 2002:a05:600c:40f:b0:38c:be5c:9037 with SMTP id q15-20020a05600c040f00b0038cbe5c9037mr18536702wmb.44.1649060556343;
        Mon, 04 Apr 2022 01:22:36 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.65])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm8666039wrv.10.2022.04.04.01.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 01:22:35 -0700 (PDT)
Message-ID: <e039827d-ab7b-1791-d06c-a52ebc949de8@gmail.com>
Date:   Mon, 4 Apr 2022 09:20:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC 3/5] io_uring: add infra and support for IORING_OP_URING_CMD
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, ming.lei@redhat.com,
        mcgrof@kernel.org, pankydev8@gmail.com, javier@javigon.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
References: <20220401110310.611869-1-joshi.k@samsung.com>
 <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com>
 <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220404071656.GC444@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/4/22 08:16, Christoph Hellwig wrote:
[...]
>> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
>> +{
>> +	req->uring_cmd.driver_cb(&req->uring_cmd);
>> +}
>> +
>> +void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> +			void (*driver_cb)(struct io_uring_cmd *))
>> +{
>> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>> +
>> +	req->uring_cmd.driver_cb = driver_cb;
>> +	req->io_task_work.func = io_uring_cmd_work;
>> +	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>> +}
>> +EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
> 
> I'm still not a fund of the double indirect call here.  I don't really
> have a good idea yet, but I plan to look into it.

I haven't familiarised myself with the series properly, but if it's about
driver_cb, we can expose struct io_kiocb and io_req_task_work_add() so
the lower layers can implement their own io_task_work.func. Hopefully, it
won't be inventively abused...


# io_uring.h

static inline struct io_uring_cmd *io_req_to_ucmd(struct io_kiocb *req)
{
	return container_of();
}

typedef void (*io_tw_cb_t)(struct io_kiocb *req, bool *locked);

static inline void io_cmd_tw_add(struct io_uring_cmd *ioucmd, io_tw_cb_t foo)
{
	struct io_kiocb *req = container_of(ioucmb...);

	req->io_task_work.func = foo;
	io_req_task_work_add();
}

>>   static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
> 
> Also it would be great to not add it between io_req_task_queue_fail and
> the callback set by it.
> 
>> +void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
>> +{
>> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>> +
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +	io_req_complete(req, ret);
>> +}
>> +EXPORT_SYMBOL_GPL(io_uring_cmd_done);
> 
> It seems like all callers of io_req_complete actually call req_set_fail
> on failure.  So maybe it would be nice pre-cleanup to handle the
> req_set_fail call from ĩo_req_complete?

Interpretation of the result is different, e.g. io_tee(), that was the
reason it was left in the callers.

[...]
>> @@ -60,7 +62,10 @@ struct io_uring_sqe {
>>   		__s32	splice_fd_in;
>>   		__u32	file_index;
>>   	};
>> -	__u64	__pad2[2];
>> +	union {
>> +		__u64	__pad2[2];
>> +		__u64	cmd;
>> +	};
> 
> Can someone explain these changes to me a little more?

not required indeed, just

-	__u64	__pad2[2];
+	__u64	cmd;
+	__u64	__pad2;

-- 
Pavel Begunkov
