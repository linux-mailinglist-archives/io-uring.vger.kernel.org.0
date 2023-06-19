Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C67357F6
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjFSNGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 09:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjFSNFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 09:05:47 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A819A7
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 06:05:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b515ec39feso6629805ad.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 06:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687179907; x=1689771907;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1I/P024fCMMLelE1sEmhap2iYAu1he9CemA40pG/1o=;
        b=A+UOHuflkA8+IvB7+jylzp5GlnfjG+sRCkDgej+cJ+mpES7rVBEqbLNH78eG9MG1m7
         KO/JM0S1iQyABQTXeDgXT5EeR69NyWLO/hyCpxuFnxCgkF42BDtCLZcMUMsq4SFSCAJj
         ZiHhYXaixd/RG3MKj+ajgn+Ul/GjIedMcwbxBdxyPxdxpM5KoNRg7kXb34nFZlc0+H4m
         Akjjh5ZhyaRrePa1h5wJyGZN41DlGRTSrh9f+iWMIy1yoylTd3hu07tnkS0WmNfISZqx
         gS5QFC/s3BmUkSQ89hqORC56U27iNWzvkFbYWhCgjrJEf4uDYcSx/1LhxSQ5+S3pKuFv
         hCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687179907; x=1689771907;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1I/P024fCMMLelE1sEmhap2iYAu1he9CemA40pG/1o=;
        b=QfGkOlp0l9JndfK7xNJCw4pUkmDyzamjBYAoNWj8nWEXENHENLHieR7io/2tYIEVK8
         gtmPusanDkvBIMTxDZvJjfHAJ9fSAPO2YxCmrl9tmT6UBrynxAERJfFRop5pMzcx3B24
         NoKOzJKDJsStaxP6Az679nN90vuIuVwY6+KZzYbESPcAM98+WAMpuZD0fHT72mV8RE/r
         GoJ9cLuWkv9s+XI6TG9CEM7G4Or7H9auiCfq284qfz0okwWiJQ+yhDc+KXzArAF1lQcl
         fQ5eRhxWWgS47OJ3SW4fGddxLVDYaQbC/pSxISzY0hmRpvrtbg8z+HPRKMDYLFyfBi2U
         nvbg==
X-Gm-Message-State: AC+VfDzKk416TJOb7ICP5sZQ7rhYyF3Y8F+M5jBWBkzmBnoZd9tjdHi3
        VB1x3o3RRE1xHfmZ0OUT8rNM7q/lkh7dXPFO0s4=
X-Google-Smtp-Source: ACHHUZ6RWKj2k3xd5Kj2RM7jJEIgC0A6EUNzmdTbiBnRfegjSXE1oroxuQNgch6t/WFtSXROjSjbIA==
X-Received: by 2002:a17:903:32c4:b0:1b0:3cda:6351 with SMTP id i4-20020a17090332c400b001b03cda6351mr12036329plr.0.1687179906928;
        Mon, 19 Jun 2023 06:05:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id je9-20020a170903264900b001a98f844e60sm8695561plb.263.2023.06.19.06.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 06:05:06 -0700 (PDT)
Message-ID: <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
Date:   Mon, 19 Jun 2023 07:05:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
 <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> If the application sets ->msg_control and we have to later retry this
>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>> need to retain the original msg_control value. This is due to the net
>> stack overwriting this field with an in-kernel pointer, to copy it
>> in. Hitting that path for the second time will now fail the copy from
>> user, as it's attempting to copy from a non-user address.
> 
> I'm not 100% sure about the impact of this change.
> 
> But I think the logic we need is that only the
> first __sys_sendmsg_sock() that returns > 0 should
> see msg_control. A retry because of MSG_WAITALL should
> clear msg_control[len] for a follow up __sys_sendmsg_sock().
> And I fear the patch below would not clear it...
> 
> Otherwise the receiver/socket-layer will get the same msg_control twice,
> which is unexpected.

Yes agree, if we do transfer some (but not all) data and WAITALL is set,
it should get cleared. I'll post a patch for that.

Note that it was also broken before, just differently broken. The most
likely outcome here was a full retry and now getting -EFAULT.

-- 
Jens Axboe

