Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2458877D14B
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbjHORrF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbjHORq6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:46:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7DD1BCC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:46:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4ff8a1746e0so862531e87.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692121616; x=1692726416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bD6WdDrr+iINFaVqPeqYqokvuGDeRsBAYmAV1xWLE8I=;
        b=IgUmBNi5NI1yvUshjfo/bFHE3bjrRyBtD3yh0tsRRwIWq7AtAesUGUou8n8FgyfeE4
         8nREvJzX6C2f3Tlp8F5ltp5UeHsxTUiYoCRvEUFi1Qcw+hdbgfI4I7CttOxH+rQQzNsM
         eD2y5kUe4WBmr9oteT+mq3j6XCIUyGtoDVnXUwFln5c5fQvnQg9Rpc23MRhAzPt2ktYM
         KUjEhMCZfumQTSvHjDHlDfY9b3sZXvDAp9itGrN0s4aH+AecslT3ncfumFLy1RWhMKaA
         jIH/qWxvvt981b+Wx2tcRcvJ3c1M3FZRyDK46sG50avPREUxQN9CGORa1prl9KjMlb8g
         wWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692121616; x=1692726416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bD6WdDrr+iINFaVqPeqYqokvuGDeRsBAYmAV1xWLE8I=;
        b=gdnyhLD9v7hV6kLLtmM6MMAa+eZVraO4jEjnxRfNqz1RebyK7E2q4AcQtlKOgjq6Bc
         EZUvkLaf/Cm5lrXJXpqvhIakRh/vbYuab41Jg+6eJB0VEuG+7kM71FuEvircvYGpwApH
         0eXDneqrCsgSAwHPbONoOMHDPWYGxUw2wBCyDdG9NEX2ouspu794I+FMlJTz7LLkHI+2
         olNTA0RtYHtZzmWOnyz/D+PqZj9FrbC8B7pwnBuO9VmCx2xrYDLtVPZqnUMb1+vOXsni
         Zd4Aw7HuyqZYSRpaWgQGOWmN3LSTmhMuONWrVOcNFkxGBLuI3RXmWNSXmiubtnOr0iTS
         /DYw==
X-Gm-Message-State: AOJu0Yyns5TyeU118ju20Fru9qhCPF7fqtD/YZGEJDpUWQxXz1UwAfrr
        aIaWBYoTs0HAgnYqgwJTJX0/+lVBwB0=
X-Google-Smtp-Source: AGHT+IGbNt0uWjaZisR0TAlsvNpnN8Dfkrigjk/rfbeM2rEPTkBK3HFjLLOgQ9o5kxtkRxtDKqtB2A==
X-Received: by 2002:a05:6512:746:b0:4fe:e50:422d with SMTP id c6-20020a056512074600b004fe0e50422dmr9535056lfs.25.1692121615722;
        Tue, 15 Aug 2023 10:46:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id b12-20020a170906660c00b00992c92af6f4sm7338073ejp.144.2023.08.15.10.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 10:46:55 -0700 (PDT)
Message-ID: <1b948d2e-c34f-6c12-cd9c-de9d42cb0fae@gmail.com>
Date:   Tue, 15 Aug 2023 18:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: move to using private ring references
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20230811171242.222550-1-axboe@kernel.dk>
 <20230811171242.222550-2-axboe@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230811171242.222550-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/23 18:12, Jens Axboe wrote:
> io_uring currently uses percpu refcounts for the ring reference. This
> works fine, but exiting a ring requires an RCU grace period to lapse
> and this slows down ring exit quite a lot.
> 
> Add a basic per-cpu counter for our references instead, and use that.
> This is in preparation for doing a sync wait on on any request (notably
> file) references on ring exit. As we're going to be waiting on ctx refs
> going away as well with that, the RCU grace period wait becomes a
> noticeable slowdown.

How does it work?

- What prevents io_ring_ref_maybe_done() from miscalculating and either
1) firing while there are refs or
2) not triggering when we put down all refs?
E.g. percpu_ref relies on atomic counting after switching from
percpu mode.

- What contexts it can be used from? Task context only? I'll argue we
want to use it in [soft]irq for likes of *task_work_add().

-- 
Pavel Begunkov
