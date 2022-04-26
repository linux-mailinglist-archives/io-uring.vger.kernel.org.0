Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6BB50FFFD
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345768AbiDZOHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 10:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351442AbiDZOHc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 10:07:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A49199802
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 07:04:19 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v12so18817939wrv.10
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 07:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0taydr0d3kKTkxP0wFKRhnRSPqyNpSH7g/WmSUV6VVU=;
        b=BzAq9gRo3dnAU93t37qjoz+H0TPvPC/FjfvXHeyxCf6PMRO0sWAJ+ESWT4dP25/7+h
         +9HqoLQovRn22Meei3Bl5hW2ND08PengKVdnckyXJd6AVecZ7Qrxqn1PbL2PaTbo7xx+
         fdbdYmlx1GgHk/10U/GEm3I5vag4ezqW47nvpmGaWd/DNtCUmBxm6TzS5mNwVzMGzYaq
         PnK0Kpdk3WtbIXsg5D3k6aJ3Pk9DAywSjwbLJ3ia9U071xrmznsoma0crD5aptnJPgek
         xahfi02LjU3zA3iil0oI+UdYGlM4ZKJytu98/y5BsuhuVMD812bI41T6lRfh7bDR0esi
         UyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0taydr0d3kKTkxP0wFKRhnRSPqyNpSH7g/WmSUV6VVU=;
        b=u8sOcYWo9U1BGfSx5PniBQy3o/H1Jk3n0MJL0EdFhcMRc9XwtOZPLYowbSqHxymcJg
         xBHPEUF8kZuhiejPaVv2ciaYGzk4sHXk28dFnhco+4IGBrZAK/sAEgpCzixY8UhuFpXq
         MbzPXos8Gyp9mYoL69bv/J8mvLkfkdRMYWM+ypEyeIAr3E+AxDJ9W8jC4SPI/5pL6/Kq
         PfQsiQlO6UhxkKiESlcwHUr2Kr1hg6/jwUfbd/9Jy+G6aRC7qiCTBNwOL0wRzIZu1JvW
         iA47c2DtNoi5SQ8CKiv52ZrnEGEXb2zuV2Axh8d4ARS3sHJ5Hfw9ZRuTjqFgAiRwjer7
         ttrw==
X-Gm-Message-State: AOAM530FW2kO+UiaDqzgy/2S0vKPgbPZ74wDdOSVWcuNCoOPEZjVLLKI
        1LS+W/OHqrGXlkPAdJevVlL9ioz4LuM=
X-Google-Smtp-Source: ABdhPJwC3lg1RjcOV2+E3YMneJmIi8IyxNxhtWTXBMtXp2rv35Dnzp3qFghuWulG32zZhYgd6D54RQ==
X-Received: by 2002:a5d:4dcc:0:b0:20a:ddaa:1c30 with SMTP id f12-20020a5d4dcc000000b0020addaa1c30mr6954577wru.419.1650981857985;
        Tue, 26 Apr 2022 07:04:17 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.233.36])
        by smtp.gmail.com with ESMTPSA id o10-20020a5d47ca000000b0020a992ce354sm13393211wrc.76.2022.04.26.07.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 07:04:17 -0700 (PDT)
Message-ID: <b04b2034-af1d-e01c-932f-3af0ca7e2846@gmail.com>
Date:   Tue, 26 Apr 2022 15:02:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v4 next 0/5] Add support for non-IPI task_work
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220426014904.60384-1-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/22 02:48, Jens Axboe wrote:
> Hi,
> 
> Unless we're using SQPOLL, any task_work queue will result in an IPI
> to the target task unless it's running in the kernel already. This isn't
> always needed, particularly not for the common case of not sharing the
> ring. In certain workloads, this can provide a 5-10% improvement. Some
> of this is due the cost of the IPI, and some from needlessly
> interrupting the target task when the work could just get run when
> completions are being waited for.
> 
> Patches 1..4 are prep patches, patch 5 is the actual change, and patch 6
> adds support for IORING_SQ_TASKRUN so that applications may use this
> feature and still rely on io_uring_peek_cqe().
> 
> v4:
> - Make SQPOLL incompatible with the IPI flags. It makes no sense for
>    SQPOLL as no IPIs are ever used there anyway, so make that explicit
>    and fail a request to setup a ring like that.
looks good

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov
