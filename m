Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089B879F234
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 21:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjIMThq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 15:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjIMThp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 15:37:45 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A45191
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 12:37:41 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-34bae11c5a6so283715ab.0
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 12:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694633861; x=1695238661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xhwqcJyiHRKzhkFLCqAMWqYlbatsaAzAVD8x6PqKtCw=;
        b=YT699XkY86ZlM0MOuldPSOGbn2Ah+9+OmoBnK/8XBwS6OmARZ02dNh4rKWnd0XpCbO
         QS3nWdDFA5MNBQy7CJYdlvJJXWyfPeiY38arccQB066IPyf4iNtdh0ushI5omZXL0jdX
         xRPSV3tDPgySipxyBxt6m6QEhrXOuq4y8LDeyZzM5Fr+KzdtqHY8ePHnl2tgUJDizS99
         XCRDMNIr4A5+Frwm1K+Omz4d8FUWurSULafeObEkB8xJT9spMHSHHkYTNzkuLXZPB/FT
         J4j8ILe9YNE8vXvstDYAb+omm7j8RzI7EhHBrLnarRiz3NEwulGWM/Ovi6jvUu5dVaIc
         6TaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694633861; x=1695238661;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xhwqcJyiHRKzhkFLCqAMWqYlbatsaAzAVD8x6PqKtCw=;
        b=MpB8/C/IsvzPi6Mr51YP0DIBBsQCLnyi2L1wqR81omF1COpjB83ILahwHJ7gUuxtPY
         udaBq4f5HvCDZrUikKr5qHcJGpAGiNcf1RDRoGnxgfQKeGA5/PVgLNMmXIB+LhdErruK
         oxKjypi7PcgF0jhLhx3yPCQ6LIyhFNyxhYmupWf4Zvt7RbKBAKFzktmomXZNYjGudl20
         kKMox2KEJHeM6TsLl/u5Q1luXlijUAtFieZ5gQLjq737cxHQS7saz1zlJrxPqdWk7yMP
         jtR7I1K3LRjogkA7rdxZ+Ez1t2jgUZ/TpM5SC8qsBj3HE9xHlJGePQkxaYzMXbLck/mQ
         K9Gw==
X-Gm-Message-State: AOJu0YyyNDrIO/vilbabif9lyQOgWbDicx1pYIgPheBzxI01I3eVSKra
        UCPFFgLYirPF+98SfC3K//ECDA==
X-Google-Smtp-Source: AGHT+IFKIK6yKbRFFo+tMkqeQy0vMUFczzDENOs7bMO2ZcLHbVid1uXdEFQsWAaRQsk0w8Gj+rWROw==
X-Received: by 2002:a05:6602:164b:b0:795:172f:977a with SMTP id y11-20020a056602164b00b00795172f977amr4169395iow.1.1694633860859;
        Wed, 13 Sep 2023 12:37:40 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o26-20020a02c6ba000000b00433f32f6e3dsm3659503jan.29.2023.09.13.12.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 12:37:40 -0700 (PDT)
Message-ID: <3b56190a-e651-43e9-ad16-0d0797593904@kernel.dk>
Date:   Wed, 13 Sep 2023 13:37:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
References: <20230913152744.2333228-1-leitao@debian.org>
 <20230913152744.2333228-7-leitao@debian.org>
 <d606f285-a31f-4b36-a7a9-bd913e1b0836@kernel.dk>
In-Reply-To: <d606f285-a31f-4b36-a7a9-bd913e1b0836@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 1:36 PM, Jens Axboe wrote:
> On 9/13/23 9:27 AM, Breno Leitao wrote:
>> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
>> level is SOL_SOCKET. This is similar to the getsockopt(2) system
>> call, and both parameters are pointers to userspace.
>>
>> Important to say that userspace needs to keep the pointer alive until
>> the CQE is completed.
> 
> Since it's holding the data needed, this is true for any request that
> is writing data. IOW, this is not unusual and should be taken for
> granted. I think this may warrant a bit of rewording if the patch is
> respun, if not then just ignore it.

reads data of course, writing into the userspace buffer.

-- 
Jens Axboe

