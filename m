Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADF66CFC0
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 20:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjAPTsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 14:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbjAPTsd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 14:48:33 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A268C2CC69
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 11:48:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z5so27448709wrt.6
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 11:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j+2DQZJ/EVkEbWDeyldgOXxaedm6hDYMndyqukEZSk0=;
        b=qLj0H5lMRBSozVFajVLzQlRCyuWS2a3yRs5MFYyqiXrpAKyP3q157netrObpMK5paU
         Zouxe7M71ntNtOhE9+fGKEVaSIgmA0rwT9/6oOSnHccVizXlGe5UfI1J7kJwuzBhp5dF
         AZOIh1FFkd7x4HFPk6AofZ3vvp0fyt2GYNcRdj46oH31kRCW5lHm7NfljBAdOjLqpJhQ
         Md6uX+FAjmF0074NRxn3soYjZdc8nLMMOJeQZYEcScGVxd9PqLGdSdDTNiswGyS3Xp1A
         CZywyO+fqd32fiMeRcyVdnu5poN3jM1G01kuLOOoXfV7OBURGsuwqoyeNPVtCK0Q+w9L
         qicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+2DQZJ/EVkEbWDeyldgOXxaedm6hDYMndyqukEZSk0=;
        b=yBOMUscT3ZZA8006yzXFlYk8ObItxQF97XzK6GddCSyO45eYqUfzjZ/WVfOvUYPomO
         QKtKk6We6YU/HfIkKvteTHnwpBleeJs5rgP1RNVx2DtT87nfjFjjtoBiOaQVH8Y3eeQZ
         NjqlyJJIMLP7QH9yEhaiOa45LA44SfnAtUGQe222rPQj0bYZcyRCpLodbsVV/0n19QBp
         yjDeMPpC9T6OkarHuKY5EqyWKEfRoqzg1eYSZ5YfKuQyIf3MwwAsv6m129B09Z9XlXLf
         iijFGiFJf0rBqDxO+5F5F3rQ4IHFgpRNTCj/RRAE9hODe4msJebxjzYo8OWWzKZ+HDmZ
         8pNQ==
X-Gm-Message-State: AFqh2koNIAOZ3fy0ppJCET2VgbB60FIzkLNrz8G/+Xvy+a22KGOI3yae
        3FI4l0FhQvJlQOUALa28UJaFpmp3ZYc=
X-Google-Smtp-Source: AMrXdXvVOzMfBG4gE3fw4iDqZ5KRvD1YHY/Ds1OZL3AjwEBKE4DrinuuuUv6kp/HhOeT+lWcOmxyDQ==
X-Received: by 2002:a5d:4fc8:0:b0:256:ff7d:2347 with SMTP id h8-20020a5d4fc8000000b00256ff7d2347mr8898243wrw.13.1673898508184;
        Mon, 16 Jan 2023 11:48:28 -0800 (PST)
Received: from [192.168.8.100] (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id e7-20020a056000120700b00241dd5de644sm27039743wrx.97.2023.01.16.11.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 11:48:27 -0800 (PST)
Message-ID: <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
Date:   Mon, 16 Jan 2023 19:47:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 18:43, Jens Axboe wrote:
> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>> io_submit_flush_completions() may queue new requests for tw execution,
>> especially true for linked requests. Recheck the tw list for emptiness
>> after flushing completions.
> 
> Did you check when it got lost? Would be nice to add a Fixes link?

fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.

Looks like the optimisation was there for normal task_work, then
disappeared in f88262e60bb9c ("io_uring: lockless task list").
DEFERRED_TASKRUN came later and this patch handles exclusively
deferred tw. I probably need to send a patch for normal tw as well.

-- 
Pavel Begunkov
