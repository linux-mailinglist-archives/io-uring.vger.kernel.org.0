Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3741679757B
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjIGPrW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 11:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343729AbjIGPbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 11:31:01 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144011BF5
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 08:30:39 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1d542f05b9aso121548fac.1
        for <io-uring@vger.kernel.org>; Thu, 07 Sep 2023 08:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694100588; x=1694705388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aWdozd3FKuPpPHCY6GD+H9s3AlMxvKZwcivHUIlCj/I=;
        b=M84rN+KyW6b62TYFJKfZVcIObJ682cByN9vZZycDr2xbiAixneic8gOUG0lSuC8nca
         TlYEYijr+zN3COSrvBSBvb2UDC7jitS+rZcoV4v2pmx64vLoD6GroQTEHpNx49uQFk/T
         yOBlsXRuH+N9JfFWc/2sSBwoAL4EuLiiwnBGicZMH+sSLOLjUx0722Nb/rn+n8bda4cN
         +k3f3R6YnbCg/fxBDGj9DhgS/R+25YqaOY0tYY17p9XvNGWy9C4j3ZFf+59WuP9GhgcH
         zhgbQqL04kl3sT9zTPlp7aav/vgjv7h7kJZSA3TVRiCFK5C0kedFC/ng9STm/3LmxltH
         dPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100588; x=1694705388;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aWdozd3FKuPpPHCY6GD+H9s3AlMxvKZwcivHUIlCj/I=;
        b=aPc4MU2GCdnIIk6+jzOMQFRlqyj0ZhP+5xTVwJxoUH9kDWX8UYV3Zp2hlKBM6I67cs
         NmI3k+gCwUVtv5ouUGyjFu+dTWxdaO1ZU/26cceLDEvAkTbkLx/xLVjPk8XTO0nri2qC
         jvIIxEEchGTztNLpkjA0g87pSjO9iTrunliHHNZF7fJ/jLInj+Owaokkpb7zOrFVTMLp
         7OsqVfXC0eL7eIneAX5XI5F8ERU6SYSmeXALqmwjFPHgLCDnD2wwX/rNFLOjqDXgiBwt
         eJOWbF9SZwDLOOi4AHJR8yha6u+KE6FxkDDZte8F48OBod185Td5eCZAK8UzTkNmxsBi
         +0Ag==
X-Gm-Message-State: AOJu0YzkHDP1ihS4PmlZCgAQ1OLn370GwxmfZ3xbb7Sk8QItQDba5lCD
        wo3wgFDYMkab93eYPQXLEnIZwPnhqGO8scuUw32OoQ==
X-Google-Smtp-Source: AGHT+IGhDuZ2pBALU3bAzvZQpgO1Y4E7un6fKAaL7xZlkqoU2FF1X1FtYwNvfS8KFk9BIIIfQ9syUA==
X-Received: by 2002:a92:d28c:0:b0:349:582c:a68d with SMTP id p12-20020a92d28c000000b00349582ca68dmr16796716ilp.3.1694098972253;
        Thu, 07 Sep 2023 08:02:52 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i11-20020a056e020ecb00b0034e1b671040sm4659779ilk.55.2023.09.07.08.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 08:02:51 -0700 (PDT)
Message-ID: <d1c82fed-6662-4d17-a3fd-d1ccfeb0abc3@kernel.dk>
Date:   Thu, 7 Sep 2023 09:02:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] for-next fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1694054436.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1694054436.git.asml.silence@gmail.com>
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

On 9/7/23 6:50 AM, Pavel Begunkov wrote:
> Patch 1 fixes a potential iopoll/iowq live lock
> Patch 2 fixes a recent problem in overflow locking
> 
> Pavel Begunkov (2):
>   io_uring: break out of iowq iopoll on teardown
>   io_uring: fix unprotected iopoll overflow
> 
>  io_uring/io-wq.c    | 10 ++++++++++
>  io_uring/io-wq.h    |  1 +
>  io_uring/io_uring.c |  6 ++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)

Thanks - applied manually, as lore is lagging for hours again...

-- 
Jens Axboe


