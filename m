Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0377CF870
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 14:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjJSML2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 08:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbjJSMLR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 08:11:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2E81B3
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 05:10:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1c9ba72f6a1so16716805ad.1
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 05:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697717455; x=1698322255; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KD/Oik8hTH6f4gOdKHL9fTSK/rIzap7qukybAYXye2U=;
        b=WXRX1eWirdh5eJisREw+YdCgIN/019mOzZMY4daI0qVaYuHyP3JnsGW2jThUz0MU+b
         NJuTHPBDqSJyD6GPcXdYkU1969gVARYpiZOktKRlvKa0z5i7TLhx4cypEWcQZ4/bRHlh
         c6tq91/x2wtLOGW61QP6pMSnOai9IV6Sk1qbHPCAecW+bj9VAS5N/drC4GxQNq16bUBF
         tvzNZXt2IAA0VJ/PDSMOHbwFjA8lG7R0WX/SS2lQcpzTbr7qSFcY6BeizB0lHRJ7tYGE
         wIipqsCaIMkkzBfoHa7f/3lcTaZw03RS65zXe3GcaNKqoxPT79QoCG+/kRs1ExCRxxD/
         5Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697717455; x=1698322255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KD/Oik8hTH6f4gOdKHL9fTSK/rIzap7qukybAYXye2U=;
        b=YfmbCAwKNLvdEr/sQNfXmYozPs/fbLhHCo9YBOL5LrQdi3eop7DiuK8lJWRUBXNKsz
         hjgkPZNGWzjH76dasjC+GDVxsbtHW6e+lXWjJiR0ipSAzRZgp+QHwdLLNl5/xxCVACxC
         vSw1Tq+NjZNr6Mr3NwdRrbr4xxDabZFGW6fugHDI5qDc0ZoewgRzsDGi1Xjrso01BVyS
         NXAU8cjYq8HECU1HfFuTZVLzCV262te7dBBqZQjmgsmf0N234HL26T7V7t+R3KL6+mmw
         kwh8098cLqKuLcijImaTqRSUFbr5OfCP0Fbf1YaAFSr6pD57fekxVf5pB/QKxKl3H2IB
         CpUw==
X-Gm-Message-State: AOJu0Yy/LgY4hfzAZQs+n03SNDjvG3TJ9Gqf0BR/vcK//NY8xXkDr+DJ
        W/nuvz8NThqxaGH4TLl+vFhj6Q==
X-Google-Smtp-Source: AGHT+IEQ9/qs8PlB4d+2Esq/iwmWJSRWB7vTowL0wDh0SwkKzoQFvyLiohJdNnFEdgk2TQAJiUiwVQ==
X-Received: by 2002:a17:903:1445:b0:1ca:1ce1:bfac with SMTP id lq5-20020a170903144500b001ca1ce1bfacmr2074597plb.1.1697717454850;
        Thu, 19 Oct 2023 05:10:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902bd4b00b001c736746d33sm1787821plx.217.2023.10.19.05.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 05:10:54 -0700 (PDT)
Message-ID: <729d8b81-fd79-48be-a59e-bf16832e9b22@kernel.dk>
Date:   Thu, 19 Oct 2023 06:10:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6.4 Regression] rust/io_uring: tests::net::test_tcp_recv_multi
 hangs
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, Guang Wu <guazhang@redhat.com>
References: <ZTDjhCk8TC47oBdZ@fedora>
 <aa10bf89-779c-4383-a36c-5615f73dc6a4@kernel.dk> <ZTEXPlB70Eqe3WOJ@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZTEXPlB70Eqe3WOJ@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/23 5:47 AM, Ming Lei wrote:
> On Thu, Oct 19, 2023 at 05:31:11AM -0600, Jens Axboe wrote:
>> On 10/19/23 2:06 AM, Ming Lei wrote:
>>> Hello Jens,
>>>
>>> Guang Wu found that tests::net::test_tcp_recv_multi in rust:io_uring
>>> hangs, and no such issue in RH test kernel.
>>>
>>> - git clone https://github.com/tokio-rs/io-uring.git
>>> - cd io-uring
>>> - cargo run --package io-uring-test
>>>
>>> I figured out that it is made by missing the last CQE with -ENOBUFS,
>>> which is caused by commit a2741c58ac67 ("io_uring/net: don't retry recvmsg()
>>> unnecessarily").
>>>
>>> I am not sure if the last CQE should be returned and that depends how normal
>>> recv_multi is written, but IORING_CQE_F_MORE in the previous CQE shouldn't be
>>> returned at least.
>>
>> Is this because it depends on this spurious retry? IOW, it adds N
>> buffers and triggers N receives, then depends on an internal extra retry
>> which would then yield -ENOBUFS? Because that sounds like a broken test.
> 
> Yeah, that is basically what the test does. 
> 
> The test gets two recv CQEs, both have IORING_CQE_F_MORE. And it waits for 3
> CQEs, and never return because there isn't the 3rd CQE after
> a2741c58ac67 ("io_uring/net: don't retry recvmsg() unnecessarily")
> is merged.

Right, and this is why it's invalid. If you send two, you will get two.
This is a misunderstanding of how recv multishot works, and the test
relied on an odd quirk where we'd sometimes re-trigger a recv even
though we did not have to.

>> As long as the recv triggers successfully, IORING_CQE_F_MORE will be
>> set. Only if it his some terminating condition would it trigger a CQE
>> without the MORE flag set. If it remains armed and ready to trigger
>> again, it will have MORE set. I'll take a look, this is pure guesswork
>> on my side right now.
> 
> .B IORING_CQE_F_MORE
> If set, the application should expect more completions from the request. This
> is used for requests that can generate multiple completions, such as multi-shot
> requests, receive, or accept.
> 
> I understand that if one CQE is received with IORING_CQE_F_MORE, it is
> reasonable for userspace to wait for one extra CQE, is this expectation
> correct? Or the documentation needs to be updated?

This is correct, if IORING_CQE_F_MORE is set, the request remains armed
and will trigger an even again. That next event may not have
IORING_CQE_F_MORE set, but there will always be that next even _as long
as something causes a new cqe to be issued_.

The test sets up two buffers, and arms a recv multishot for them. It
then proceeds to send two buffers, which are received and completed.
Each of those CQEs will have MORE set, because they both completed
successfully, and if someone sends more data, it will trigger again.
What the test should do is ensure that another recv is triggered, I've
attached a dummy patch below.

This is simply a broken test. No errors have occurred (eg running out of
buffers, or receive being shorter than it should be), hence there's no
reason for io_uring to terminate the multishot request.


diff --git a/io-uring-test/src/tests/net.rs b/io-uring-test/src/tests/net.rs
index 18beb20773cf..82208443f2df 100644
--- a/io-uring-test/src/tests/net.rs
+++ b/io-uring-test/src/tests/net.rs
@@ -1100,7 +1100,9 @@ pub fn test_tcp_recv_multi<S: squeue::EntryMarker, C: cqueue::EntryMarker>(
     // Send one package made of two segments, and receive as two buffers, each max length 1024
     // so the first buffer received should be length 1024 and the second length 256.
     let mut input = vec![0xde; 1024];
-    input.extend_from_slice(&[0xad; 256]);
+    input.extend_from_slice(&[0xad; 1024]);
+    let mut enobufs = vec![0xff; 256];
+    input.append(&mut enobufs);
     let mut bufs = vec![0; 2 * 1024];
 
     // provide bufs
@@ -1118,7 +1120,7 @@ pub fn test_tcp_recv_multi<S: squeue::EntryMarker, C: cqueue::EntryMarker>(
     assert_eq!(cqe.user_data(), 0x21);
     assert_eq!(cqe.result(), 0);
 
-    // write all 1024 + 256
+    // write all 1024 + 1024 + 256
     send_stream.write_all(&input)?;
 
     // multishot recv using a buf_group with 1024 length buffers
@@ -1143,7 +1145,7 @@ pub fn test_tcp_recv_multi<S: squeue::EntryMarker, C: cqueue::EntryMarker>(
     assert_eq!(&bufs[..1024], &input[..1024]);
 
     assert_eq!(cqes[1].user_data(), 0x22);
-    assert_eq!(cqes[1].result(), 256); // length 256
+    assert_eq!(cqes[1].result(), 1024); // length 1024
     assert!(cqueue::more(cqes[1].flags()));
     assert_eq!(cqueue::buffer_select(cqes[1].flags()), Some(1));
     assert_eq!(&bufs[1024..(1024 + 256)], &input[1024..(1024 + 256)]);

-- 
Jens Axboe

