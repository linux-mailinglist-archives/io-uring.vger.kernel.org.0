Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55B47D122F
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 17:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377626AbjJTPGi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377634AbjJTPGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 11:06:36 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68558D52
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 08:06:34 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-578bb70ad89so26251a12.0
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 08:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697814394; x=1698419194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJ+NTvwdtW3FTxf6IDZc9EfFbtlXlURfoCur41wmHy4=;
        b=VBUetzg4Z9HGW0Cav88NbIIx76cTDVb2L3a4qsVKlFdIyuuG7RHVtQ4WDN0NySKobA
         5UAzI1h6RXGxhedYTxSAZQVBfpuxaQXl29fHdbNGUCWDCNFkISLVtoyNNku/YlZo92wG
         Qxq+FagyYaRo2gOzU9MmXxYsOCKTnNkQDz+QATCfjUsvEn06FySFfnOaY2V9JIA6AWOw
         k68drZ64wL2gSFAvzSWwuhq1IbYYpoP0uUIgB881fvmAWaORZk1UOtKC1dPq3JsuGehx
         M2ph11Lf8qpXSynpxvWKEsNh3Kd7MDYJT7SFBhAn7fqa8UFzjy9CzeCpxxZ+tyGLNJM/
         RkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697814394; x=1698419194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJ+NTvwdtW3FTxf6IDZc9EfFbtlXlURfoCur41wmHy4=;
        b=YkbuXGXviOwZ2vXjnfhBSjksUjyowYyXSjF0iZ+7kk5nuaWSnb5Z2TYLvzPSh9/Th/
         5DJa+viY53KIqiRW7uSMO/QqEMW8faC8K79vp5e/nPObw5HbLMndFd4Y1IZ37OqyUDpl
         3RwdvvlmBUPyZteXeDw9wmh0q4l25LDsB3t5TJ+9eK3KqMEp/STezvs56XotwRPA3u2e
         GD6yfs2NQZX/lMuM1qpAuIoMsakkimsO3fuhQGjSEWg3YjhJdjAjPcUZLtmYJFIGT5vz
         z46SQAsHCd3Qh0epjpkflGExBhGkdUpnV9nDY63C4VZGlAjtRAR6bA8M7wJjt3vDP4Ef
         jTjg==
X-Gm-Message-State: AOJu0Yyfk+lYGwP1VWqaNAXP6t6CrMwwDdZGnSO1DyYuFpbNh4hhlkMY
        neF50wRhEmv89Nx3WY/w0YCojYhAXdhdxFssF8h/qQ==
X-Google-Smtp-Source: AGHT+IHq7TYyaX3SJ6o88GoXkY9VLW6HtlnCExM0ZmrU9e9jiiFFbiSDeFWowAFEs7hGYTRdvzRc8g==
X-Received: by 2002:a05:6a21:3286:b0:163:ab09:196d with SMTP id yt6-20020a056a21328600b00163ab09196dmr2204858pzb.1.1697814393835;
        Fri, 20 Oct 2023 08:06:33 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id i14-20020a056a00004e00b006a77343b0ccsm1637719pfk.89.2023.10.20.08.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 08:06:33 -0700 (PDT)
Message-ID: <b62f87f1-ecb8-4fd3-99b7-f53d67909d70@kernel.dk>
Date:   Fri, 20 Oct 2023 09:06:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] liburing: Add {g,s}etsockopt command support
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org
References: <20231020133917.953642-1-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
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

On 10/20/23 7:39 AM, Breno Leitao wrote:
> These are liburing patches that add support for the new
> SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT socket
> commands.
> 
> This patchset basically synchronize the UAPI bits, teach
> io_uring_prep_cmd(3) how to use the new fields, create a unit test and
> add the proper man page documentation.

Applied to the 'next' branch. Had to hand apply patch 2, but the rest
applied just fine.

Thanks!

-- 
Jens Axboe


