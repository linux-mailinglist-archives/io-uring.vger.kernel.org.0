Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC147A4A34
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 14:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbjIRMyq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 08:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241617AbjIRMyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 08:54:41 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15278A8
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 05:54:36 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5783e07fdcbso110726a12.0
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 05:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695041675; x=1695646475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWGPTo1ZvfuUjNg1XUW38hl8yK4OGYjL6QNtvfdy6vg=;
        b=YLxMPmWWk1Gtnm/5DsxfQBnyzPFzHFukCGG+t2lvWjvrXsXAWYAptxnJbfCT6yzQ3x
         rnWg/5rMS2ZFBaVVxoMm48YmjmDEgCf7aEM+JQEPrMo3hmde95RPJDWKrQVpOf0xgQQn
         gjJ858d+UaM+oiZQF3SECJh/bjtX0sS32iowltcVXgCBMN+4my83IxEKZc+KFba/pwRR
         UdKIOS3arAv3wPrwzmhoLGxJkZXEuanNl2Ya5jUZaNW0KV+eleT7RZgS5Y9Pd1Cfc69A
         ze6A9isc6rA2Y7lwEI0MHNiXBJwj9/Bxp+/oIlj/h4Y6XCwzUBR0L/hWfZflvI1nnHil
         m9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041675; x=1695646475;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWGPTo1ZvfuUjNg1XUW38hl8yK4OGYjL6QNtvfdy6vg=;
        b=TIP9zxg/J8s6FX7Tj5hLtg5Fa+kGAlAUn5MTE3rw9OZq/ojdhHoMXgDUXrNK+Mjdtd
         ezUZ0oq+Yg5mBXQG8ujAA/zhmanNYWR4VMlcLZ/LytzFOWWTj12yIERq8dLv9grXKXX4
         kH+QhjrgFqy5FEnaOfEmySgSnH4HvaLd/B4t7Ja+IAWWulcTRqh7CvzTDCVpaT3qnT5i
         6AictRW6zYOmgvZSVtbXFKm0Yfj2Z8sffyI06J6W9L52x/qV0Cag58AcLhpAYbO0rA4g
         VMH5vA8fXk4OB3lcqd0NCifLVe+LkemBZSyFydbuhDUsidfFjYRCDa3YaQS7eQqbGcgX
         ocuw==
X-Gm-Message-State: AOJu0Yxixe/d2cxwRTsofHXcE+Gl5R53af7s4VvH2qctWF+9+7QDvGVF
        xYjqtmuVTbbj92LtnFHmCmNfQg==
X-Google-Smtp-Source: AGHT+IGX7VvdwZmie4r1BP3W4CjS0WgfXtv2/ZI/UiSSocpoMYtDD+uTqQYoGeAnqTd9g1h7xJzbzA==
X-Received: by 2002:a05:6a20:394c:b0:15a:2c0b:6c81 with SMTP id r12-20020a056a20394c00b0015a2c0b6c81mr9915610pzg.3.1695041675493;
        Mon, 18 Sep 2023 05:54:35 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e23-20020a62ee17000000b006889081281bsm7005760pfi.138.2023.09.18.05.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:54:34 -0700 (PDT)
Message-ID: <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk>
Date:   Mon, 18 Sep 2023 06:54:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] io_uring/ublk: exit notifier support
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
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

On 9/17/23 10:10 PM, Ming Lei wrote:
> Hello,
> 
> In do_exit(), io_uring needs to wait pending requests.
> 
> ublk is one uring_cmd driver, and its usage is a bit special by submitting
> command for waiting incoming block IO request in advance, so if there
> isn't any IO request coming, the command can't be completed. So far ublk
> driver has to bind its queue with one ublk daemon server, meantime
> starts one monitor work to check if this daemon is live periodically.
> This way requires ublk queue to be bound one single daemon pthread, and
> not flexible, meantime the monitor work is run in 3rd context, and the
> implementation is a bit tricky.
> 
> The 1st 3 patches adds io_uring task exit notifier, and the other
> patches converts ublk into this exit notifier, and the implementation
> becomes more robust & readable, meantime it becomes easier to relax
> the ublk queue/daemon limit in future, such as not require to bind
> ublk queue with single daemon.

The normal approach for this is to ensure that each request is
cancelable, which we need for other things too (like actual cancel
support). Why can't we just do the same for ublk?

-- 
Jens Axboe

