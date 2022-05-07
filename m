Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6E51E704
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 14:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351195AbiEGM5V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 08:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiEGM5U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 08:57:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515513EBAD
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 05:53:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso9067678pjb.5
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 05:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qBW1EXKGUeQrlcaUCq/1s8UAzcPPcWNYauWhX+6w4hY=;
        b=vlBQ8e1xW2V0wpHdIzbgo+jglaeGGZLPL6LYA8iGYfrantof/N7FW8eOJNsewQxYhS
         wa2Tt8kKKnyTx6ZzQ9biCYwISFfw6ubjms8Gg6q0Vb1jWt7rD2sE1hYy5muS7L3ltQme
         1tMvze3FwD+53PRp3BLqIAVLTlHAtVrg8d5vfy7F0F4yQtbwjXRNeEDves2XQEXx7Fhl
         QuDrl86dbymzLCPmPFpWC9eBMuBnX3gm7W95j5ggxN0XUZZBUFVUorGMq4Ztw5/r/C6U
         zRrDCg8yyDF55qpBD3ofIfM05udL8GNF9y7fNxNYXlj6DRMZ0N7K02o09QIoNfGYh6Um
         CyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qBW1EXKGUeQrlcaUCq/1s8UAzcPPcWNYauWhX+6w4hY=;
        b=OXqgHsiQgt19lwNvAJET9ow44WhB9gs/bbduOQAQ/3qU9e3yGPsfxkEztddaLHRb+O
         X9gVk13PvoUhgt791yrmqwhtCwDMBxSuOyd5HeP2wAS/+2izEreI2kJeu/2DRiBG52XJ
         yU2mLrPiUiEpdxSp9E7FBzHajB4OFLC5wWRl7iVJgVtOsVJjMqiCLJ8eW0vSBmfmIdVD
         4ttBvlujsGoggofUZpfMAdm4WNOa5I2RNA/xOV9xbxsRuG8AzxC3ErwoQkmra8c/k7hd
         7HweBCIpBTDc/2HVHiEOaQ/UR24vaC96iIWCfpGO8EMWOXQ7tSY7K8C6VopFbE4JAB+2
         2qhQ==
X-Gm-Message-State: AOAM533YwxdlDqPlAZjzHgf8K51mkqHWtQI8au8xxPWUR7z0xYTA84Ug
        aam0RcMtzaTRfQj9Ks9QQSJNJr4e+AD7ow==
X-Google-Smtp-Source: ABdhPJwg0Pxo91rBnLOcJHAYfdSXGgBf3FrwDBoOVvOt4TBI13HNJZ/EhYdxfTGetwUkqeRfvMjI/Q==
X-Received: by 2002:a17:902:c952:b0:15e:9e3d:8e16 with SMTP id i18-20020a170902c95200b0015e9e3d8e16mr8448104pla.51.1651928012758;
        Sat, 07 May 2022 05:53:32 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902968c00b0015e8d4eb244sm3584932plp.142.2022.05.07.05.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 05:53:31 -0700 (PDT)
Message-ID: <d315712a-0792-d15f-040d-3a3922700a53@kernel.dk>
Date:   Sat, 7 May 2022 06:53:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
 <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
 <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
 <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
 <20220506082844.GA30405@lst.de>
 <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
 <20220506145058.GA24077@lst.de>
 <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk>
 <20220507050317.GA27706@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220507050317.GA27706@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 11:03 PM, Christoph Hellwig wrote:
> Getting back to this after a good night's worth of sleep:
> 
> On Fri, May 06, 2022 at 08:57:53AM -0600, Jens Axboe wrote:
>>> Just add this:
>>>
>>> "Add a small helper to act as the counterpart to nvme_add_user_metadata."
>>>
>>> with my signoff:
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Both done, thanks.
> 
> I think we're much better of folding "nvme: add nvme_finish_user_metadata
> helper" into "nvme: refactor nvme_submit_user_cmd()" as the first basically
> just redos the split done in the first patch in a more fine grained way
> to allow sharing some of the metadata end I/O code with the uring path,
> and basically only touches code changes in the first patch again.

Yes good point, I've folded the two.

>>>> I did not do your async_size changes, I think you're jetlagged eyes
>>>> missed that this isn't a sizeof thing on a flexible array, it's just the
>>>> offset of it. Hence for non-sqe128, the the async size is io_uring_sqe -
>>>> offsetof where pdu starts, and so forth.
>>>
>>> Hmm, this still seems a bit odd to me.  So without sqe128 you don't even
>>> get the cmd data that would fit into the 64-bit SQE?
>>
>> You do. Without sqe128, you get sizeof(sqe) - offsetof(cmd) == 16 bytes.
>> With, you get 16 + 64, 80.
> 
> Can we please get a little documented helper that does this instead of
> the two open coded places?

How about we just add a comment? We use it in two spots, but one has
knowledge of the sqe64 vs sqe128 state, the other one does not. Hence
not sure how best to add a helper for this. One also must be a compile
time constant. Best I can think of is the below. Not the prettiest, but
it does keep it in one spot and with a single comment rather than in two
spots.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1860c50f7f8e..0a9b0fde55af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1044,6 +1044,14 @@ struct io_cancel_data {
 	int seq;
 };
 
+/*
+ * The URING_CMD payload starts at 'cmd' in the first sqe, and continues into
+ * the following sqe if SQE128 is used.
+ */
+#define uring_cmd_pdu_size(is_sqe128)				\
+	((1 + !!(is_sqe128)) * sizeof(struct io_uring_sqe) -	\
+		offsetof(struct io_uring_sqe, cmd))
+
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -1286,8 +1294,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
 		.plug			= 1,
-		.async_size		= 2 * sizeof(struct io_uring_sqe) -
-					  offsetof(struct io_uring_sqe, cmd),
+		.async_size		= uring_cmd_pdu_size(1),
 	},
 };
 
@@ -4947,11 +4954,9 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
 static int io_uring_cmd_prep_async(struct io_kiocb *req)
 {
-	size_t cmd_size = sizeof(struct io_uring_sqe) -
-				offsetof(struct io_uring_sqe, cmd);
+	size_t cmd_size;
 
-	if (req->ctx->flags & IORING_SETUP_SQE128)
-		cmd_size += sizeof(struct io_uring_sqe);
+	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
 
 	memcpy(req->async_data, req->uring_cmd.cmd, cmd_size);
 	return 0;

-- 
Jens Axboe

