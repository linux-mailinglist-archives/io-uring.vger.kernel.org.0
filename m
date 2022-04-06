Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E1B4F60AB
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiDFNyv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 09:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiDFNyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 09:54:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3579254955
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 19:20:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id kw18so1208368pjb.5
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 19:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UuZ07fne7cOeaPij2szMafXMKGb2c0+hme5ZUM/m7BU=;
        b=FywLSI4JkLPTp/DUUZNtz46VHbLH/V7IyNLeUNZflMQSYTN/XhTLXdnikBK7GwBLj/
         D92tTemnZJIY/E+V18VglsXebKEIpzXl8OdvYYk3mvBLnv1rgzeddhE2JnBqyM1kidJO
         tLQ2/jW4edm9AiDideDk3qic+WEUWvIGmzhxGqHxQPxzaP8qYCyNnykkwZ+Ohs4AMKdW
         hm+TWYXgg3rmFIrABj8jrh/+OvHbfthD70LX+FhHV6FL6x3JmXBLlEhGvR7IrDbLapVk
         W1uW0ZZh/OzqIIfoKtD5RInUddi9EHqh3P0KCUsmivw5/om25RezAjKCKL87LiX9x+ho
         FaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UuZ07fne7cOeaPij2szMafXMKGb2c0+hme5ZUM/m7BU=;
        b=DyzHjL62+2ccnaIY0ZNOwBwht/wMROOnsfdjLoV1r2S0UFFLclKYjfj3h0ErG7on3v
         QY2fBy4diAzhiA310dmoaTYUvt2ebG7vzzxqP4M3U4RuU6tZdZx4+nCmYYjiobmPk3q1
         oHeeydwuz9aKZ3SMKiKxdmRRefq7WxwfWcmYGk/IfLSM5ASwu8p4BlK3Q7PixP8az+Lz
         2G9wUxURFVxI+m7fOkwRZmpBs4w0p13HVV1fXpvNXWgwUlRLTlBqJfhDC+b+U9eRKWNl
         I1gG/XQLSIxToqxGrW6bNrWrwcQLPCFTEkpZ+t4FXSIdG7ggLqSEi4hQsZPi9w5pJ+Sr
         T/ig==
X-Gm-Message-State: AOAM530Y+syxxLTeBST5qBMKJfwgXxQm8PyfrXOLL5tueefK6ZqmDH6F
        mFcoVxB5rALONonACbe9xvRQbZhnWZopoQ==
X-Google-Smtp-Source: ABdhPJy7qANZ6iCMXtKpDYGNiYxjP6EZ88OvDLi7iGNtJSeWFs51JSUlbeaxWxtE/azRK6QeKu+ZnQ==
X-Received: by 2002:a17:902:ef47:b0:156:646b:58e7 with SMTP id e7-20020a170902ef4700b00156646b58e7mr6231313plx.57.1649211627160;
        Tue, 05 Apr 2022 19:20:27 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm14228858pgn.2.2022.04.05.19.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 19:20:26 -0700 (PDT)
Message-ID: <f2819e9f-4445-5c5a-2a68-1d85f4bc341a@kernel.dk>
Date:   Tue, 5 Apr 2022 20:20:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>
References: <20220403114532.180945-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220403114532.180945-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 5:45 AM, Ming Lei wrote:
> -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> io_iopoll_check doesn't handle this situation, and io hang can be caused.
> 
> Current dm io polling may return -EAGAIN after bio submission is
> returned, also blk-throttle might trigger this situation too.

I don't think this is necessarily safe. Handling REQ_F_ISSUE from within
the issue path is fine, as the request hasn't been submitted yet and
hence we know that passed in structs are still stable. Once you hit it
when polling for it, the io_uring_enter() call to submit requests has
potentially already returned, and now we're in a second call where we
are polling for requests. If we're doing eg an IORING_OP_READV, the
original iovec may no longer be valid and we cannot safely re-import
data associated with it.

Hence I don't think the patch is safe and we cannot reliably handle this
scenario. dm would need to retry internally for this.

-- 
Jens Axboe

