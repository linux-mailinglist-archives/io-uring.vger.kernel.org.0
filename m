Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC579881C
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbjIHNuW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 09:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243466AbjIHNuV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 09:50:21 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AC41FEB
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 06:49:56 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-34f17290a9cso2491635ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Sep 2023 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694180995; x=1694785795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FpgQK4s9bxFZTeQvTu525yORG+W4/IPY9nrdSs2ErBA=;
        b=DxJvILV9AnF8CzcYw01F7csW8NmvK0ne/j+DwDfRa1Lamag+hkoiu2nvdkUYTjMtD6
         7zmZ38YhhW3vZ5Ghtnu51Raqzzh3UgtNIJA9faL3qGpKJLCSTiAmbg3Nh86vnQcaWQ6t
         sRuM+qzwBbjAY9Z7tjk5kNWS2ctFpXw6AdeD0vogJD/TnJj2+cqDlu1ASZNZf9vpsEkG
         BcJzDTQ3wVRdHJ5Jpk2rZpn0AErjCbiqiuvuX3jeRsT1u89yO+xkOSFpm7TG1+VhKNwT
         Mammgx4yquv3b9zG46gV5rUVQKUV4P63KkqPZkqxVT8L12JVSCAwSxC3p+mdojJIzUUt
         WQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694180995; x=1694785795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FpgQK4s9bxFZTeQvTu525yORG+W4/IPY9nrdSs2ErBA=;
        b=WFpgMUC6sE/QGHeXM2wzXcBvH42/28qVvVkZr/N7SuuqfKYd4RuAyfa6pP4iGnP5tO
         fiTjs4ADnqiq+u3pLd1iZcIs+yLLUOSF+AfzxlFNPU1JVdmf+zruKBYPisDKNt2rruZu
         WlkJDACbo7x6biuwicmEW/ld5p4Npp7xqqhR5d6nUjoWF6svjO39RzCNNE+WDcuR1koU
         SGVxSNHFaxk4uxJb817ugrZ3EaXDoSlwlKVgVY5hBrQ4hPIIfHER6OUkjDFxaElsBng6
         Mj24es0ipO0R/o0Ut9z3/xDGUEXW1KIQFvQgZEvq01D1WpRKyRmWMaQujaMZKMjdtGsX
         efyw==
X-Gm-Message-State: AOJu0Yx2zL2RyQFen/5EYRhFAMfmSVRBMM753hDhHXZf7Ymnad5IGXmA
        yVm2CG8tf+5hAylgpNkDlDgWmA==
X-Google-Smtp-Source: AGHT+IE9cEuYRFuFLiV85DC7b+ok0R2sZd3fg/+FWwWSVHviDBmJp21O8/u9JNbObSPCgRTJbeS+Lw==
X-Received: by 2002:a05:6602:14ca:b0:792:6be4:3dcb with SMTP id b10-20020a05660214ca00b007926be43dcbmr3438299iow.2.1694180995470;
        Fri, 08 Sep 2023 06:49:55 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q7-20020a02c8c7000000b004300eca209csm461203jao.112.2023.09.08.06.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Sep 2023 06:49:54 -0700 (PDT)
Message-ID: <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
Date:   Fri, 8 Sep 2023 07:49:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230908093009.540763-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230908093009.540763-1-ming.lei@redhat.com>
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

On 9/8/23 3:30 AM, Ming Lei wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ad636954abae..95a3d31a1ef1 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
>  		}
>  	}
>  
> +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> +		issue_flags |= IO_URING_F_NONBLOCK;
> +

I think this comment deserves to be more descriptive. Normally we
absolutely cannot block for polled IO, it's only OK here because io-wq
is the issuer and not necessarily the poller of it. That generally falls
upon the original issuer to poll these requests.

I think this should be a separate commit, coming before the main fix
which is below.

> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  		finish_wait(&tctx->wait, &wait);
>  	} while (1);
>  
> +	/*
> +	 * Reap events from each ctx, otherwise these requests may take
> +	 * resources and prevent other contexts from being moved on.
> +	 */
> +	xa_for_each(&tctx->xa, index, node)
> +		io_iopoll_try_reap_events(node->ctx);

The main issue here is that if someone isn't polling for them, then we
get to wait for a timeout before they complete. This can delay exit, for
example, as we're now just waiting 30 seconds (or whatever the timeout
is on the underlying device) for them to get timed out before exit can
finish.

Do we just want to move this a bit higher up where we iterate ctx's
anyway? Not that important I suspect.

-- 
Jens Axboe

