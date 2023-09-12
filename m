Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0193479C18B
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjILBQz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 21:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbjILBQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 21:16:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE806A6D
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:54:49 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c0efe0c4acso8939845ad.0
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694480023; x=1695084823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R/LjjFa9PYQ7y7hreBeXVB2P2KcHfQopmSu7JB/Y4xg=;
        b=PKxWBAHEc3ZAO5gL8Eo5VmkghvKfvQIB5kkbOmh2pIuSWu+mvxEIV+LckADH1Oth8a
         Snn0YOkZTxR6kSvh3cxhEVQ9Ml/qLpF1qZchieJeJo0Wq/tF73yOvoZa0eKSY63VXkI8
         kCJk4hM7zObPaWYEuHwwjwCP9gOBtKTmZBUyluYLM1zp+xK38nyy/ImYPvGpLpA/xAUW
         gZCu5TQXwwyG3+3MhaYO8NuSRRW9osmYzqKk2emGZLE1vWv5wGvmCZFFPH5nYSoNd6lM
         w/4SE+cx6vooF92fdcTvZQj56jGn9UFqQm1+Hh7l3tklYevqHqRPUNkej3qYwB9zUMxL
         vmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694480023; x=1695084823;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/LjjFa9PYQ7y7hreBeXVB2P2KcHfQopmSu7JB/Y4xg=;
        b=qaT0xxyW8dBv9W94VAbxiKfzNcC0gDpOqkM+pJqWrUcNh4NDuvnzZfgA6TAVfLu6/c
         Jy8vZifTIPCVKBUZE/45hLgRn8rmSyugnxx1r+7DqGRlbxgauxljP4I+nZhwg2f/2kX4
         M4V02AYaVcrx1EJzDdWzLMxkn8+Q3l8s9AA+GWcHVtk0jqZ1NcAtGYs4mio8hbSIKxel
         lWfoDMhq/B0FDiYB0ODTXAxA6izu2el1OATRICUIeEhSoh+4nmRqoL5+ZEqTFkVHy7Oa
         hRmpMK25RXsEESgweKsBRwmgNTbNXjx98cDPEPvh9s6Al6jyD4PxGtNeDs8z1jetGt16
         G74w==
X-Gm-Message-State: AOJu0Yzatw4cZW2xlqyW2OXoTZ2OUcmpxizWOKJpuDjHXT+Fxs40BVI2
        Ube0DSl8E9UdomySGYnAygW0g1uucZ05wt5gtH/fIg==
X-Google-Smtp-Source: AGHT+IGM9cgiNpMnqNfE7ieupWmsw4kOoKiHsU7qn6YDV+fCNqaO/eQ7CmuK1KTzn5nv7n4Z4QRiPg==
X-Received: by 2002:a17:902:e84c:b0:1bf:349f:b85c with SMTP id t12-20020a170902e84c00b001bf349fb85cmr13649553plg.1.1694480023070;
        Mon, 11 Sep 2023 17:53:43 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902ee5100b001bde65894d5sm7073993plo.109.2023.09.11.17.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 17:53:42 -0700 (PDT)
Message-ID: <57e19ee6-2a68-4ac7-98c7-03b3f526d3b3@kernel.dk>
Date:   Mon, 11 Sep 2023 18:53:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20230911204021.1479172-1-axboe@kernel.dk>
 <20230911204021.1479172-4-axboe@kernel.dk> <87o7i85klx.fsf@suse.de>
 <56f52ace-0e6b-46c2-83c1-98b54cf5bd0b@kernel.dk>
In-Reply-To: <56f52ace-0e6b-46c2-83c1-98b54cf5bd0b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/23 6:46 PM, Jens Axboe wrote:
>>> +	ret = __io_read(req, issue_flags);
>>> +
>>> +	/*
>>> +	 * If we get -EAGAIN, recycle our buffer and just let normal poll
>>> +	 * handling arm it.
>>> +	 */
>>> +	if (ret == -EAGAIN) {
>>> +		io_kbuf_recycle(req, issue_flags);
>>> +		return -EAGAIN;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Any error will terminate a multishot request
>>> +	 */
>>> +	if (ret <= 0) {
>>> +finish:
>>> +		io_req_set_res(req, ret, cflags);
>>> +		if (issue_flags & IO_URING_F_MULTISHOT)
>>> +			return IOU_STOP_MULTISHOT;
>>> +		return IOU_OK;
>>
>> Just a style detail, but I'd prefer to unfold this on the end of the
>> function instead of jumping backwards here..
> 
> Sure, that might look better. I'll make the edit.

Actually we can just indent the next case and get rid of the goto
completely:

int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
{
	unsigned int cflags = 0;
	int ret;

	/*
	 * Multishot MUST be used on a pollable file
	 */
	if (!file_can_poll(req->file))
		return -EBADFD;

	ret = __io_read(req, issue_flags);

	/*
	 * If we get -EAGAIN, recycle our buffer and just let normal poll
	 * handling arm it.
	 */
	if (ret == -EAGAIN) {
		io_kbuf_recycle(req, issue_flags);
		return -EAGAIN;
	}

	/*
	 * Any successful return value will keep the multishot read armed.
	 */
	if (ret > 0) {
		/*
		 * Put our buffer and post a CQE. If we fail to post a CQE, then
		 * jump to the termination path. This request is then done.
		 */
		cflags = io_put_kbuf(req, issue_flags);

		if (io_fill_cqe_req_aux(req,
					issue_flags & IO_URING_F_COMPLETE_DEFER,
					ret, cflags | IORING_CQE_F_MORE)) {
			if (issue_flags & IO_URING_F_MULTISHOT)
				return IOU_ISSUE_SKIP_COMPLETE;
			return -EAGAIN;
		}
	}

	/*
	 * Either an error, or we've hit overflow posting the CQE. For any
	 * multishot request, hitting overflow will terminate it.
	 */
	io_req_set_res(req, ret, cflags);
	if (issue_flags & IO_URING_F_MULTISHOT)
		return IOU_STOP_MULTISHOT;
	return IOU_OK;
}

-- 
Jens Axboe

