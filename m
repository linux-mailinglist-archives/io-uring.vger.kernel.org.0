Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9F6BFB61
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCRQAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCRQAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:00:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20418149A2
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:00:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o11so8259982ple.1
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679155202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujLt5tF0eX4LA+7P68DcMNj/yffL9SL6MvMgWCmQOuI=;
        b=zjSrtVHqM9M9hZlrhDfpMPM2zV/3wynZaaj9Pi7BdceNbXE6SKM9JBapIqj4VsVghk
         Adh8xVhy7ecgioQ1EvGleK1ee3/bMCn20oLjEpCixPJWw9N1jbJJSYGkoTYBnnPU6JKJ
         +GAFvNBdOPBhD6ltaIRVBpJW3SgImHXMcUARc4dVUjCM8OZKOK5vp8vYGWJ3oUQ3uyFH
         vS/Gek89rGMns+avVT8wxAfqE5O6/1C+WOCO2HCaRShCwNZFyohw6hz4j0q3HFbOErdy
         9DvR/1bAMrsyfiS66uro+2IHU5PMbKaWU1K5fwUoZuEcUCGOpMkF58RcAQaGYszlotIO
         WsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679155202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ujLt5tF0eX4LA+7P68DcMNj/yffL9SL6MvMgWCmQOuI=;
        b=undvkY1DlJD+tPlzXKiN/2zPoLJnc0xdmI3HzPRkfFVCggt1klGKuivIS/K0fGu0Mg
         7EhFwEkHhuVl/mofBNUv9xAr5Nsbzb4/swBmZDAL8VDuYNWKmvfrCrFFHO62a0zpD1QS
         EAArZYZ0HT8oAt7o5aLFyjOvQyaR2FH6htkcrXJSukRGH+krJ8EQgc/DXncrVs2Q5/wU
         /cZt+dHSVAnQJP2c3VMdYJQCv06r3VEtUnjN5PDGc8k9zc8YfUcOicEmSCNceMa2trVE
         8c1AverYie5OegUB9X5JilTI4UiTU6LyVG+JuZbFXcVmxbyuDSEYvkJbqfHwoFbKOKoa
         zg0A==
X-Gm-Message-State: AO0yUKWzT4H4amalaCtYfs5Ap/yZVJnagYYmWpDPoGinBafu6OKBXDCj
        M3SC8+ZRZr4iwR4P3Tjh/7Ndow==
X-Google-Smtp-Source: AK7set+4FLIWVOUWseASDMYHUVZuTzOk/D4xaN5IqRKIUcLCpClU2Am4rXSvHFMQ6WwZa1olQg0uLg==
X-Received: by 2002:a17:902:d3c9:b0:1a0:53ba:ff1f with SMTP id w9-20020a170902d3c900b001a053baff1fmr11475850plb.0.1679155202519;
        Sat, 18 Mar 2023 09:00:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l18-20020a17090add9200b0023530b1e4a0sm3283162pjv.2.2023.03.18.09.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 09:00:01 -0700 (PDT)
Message-ID: <82959da2-7c98-f9be-5cb2-26bb739790fd@kernel.dk>
Date:   Sat, 18 Mar 2023 10:00:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH V3 02/16] io_uring: add IORING_OP_FUSED_CMD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <20230314125727.1731233-3-ming.lei@redhat.com>
 <e92b121c-553a-b699-11ca-746ff2522d7e@kernel.dk>
 <ZBXXl1hftxHI46hV@ovpn-8-18.pek2.redhat.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZBXXl1hftxHI46hV@ovpn-8-18.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/23 9:24?AM, Ming Lei wrote:
>>> +int io_import_kbuf_for_slave(unsigned long buf_off, unsigned int len, int dir,
>>> +		struct iov_iter *iter, struct io_kiocb *slave)
>>> +{
>>
>> The kbuf naming should probably also change, as it kind of overlaps with
>> the kbufs we already have and which are not really related.
> 
> How about _bvec_buf_ or simply _buf_?

Either one is fine, buf probably good enough and makes it a bit shorter.

-- 
Jens Axboe

