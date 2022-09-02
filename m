Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4E5AAE2E
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiIBMLt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 08:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiIBMLm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 08:11:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5006B5335
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:11:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t5so1895003pjs.0
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 05:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=46aBPLkIQvF4Zc2qaB+8IQ8PDaV7KU+uxNNMa3ojlI8=;
        b=Mf3vAf5q6Lqq/fVLwDtwp/S6C0omt7HLkuQ+8tZ4VTsB6aqSWyXuJUfAp2l5oLxZOj
         oV7gv0gq28s1EJK2ocvv2CDFQlJljknGmiDZwG+3/ykGpMelXN9zZdeOwf6KIZVQg7fJ
         6wm7QqyLXYD9FEVT0KavELWgGAYMmaVquDK8k0rSeog3I0TEQTBb8N1s2z3IFSwizWVo
         Y2m6QYJZ/9uzZFRgeSjWmjPtEk+SSJ42Q+ian4AjfjhApNGtuUIQQTUJcpFJHzmOtEmt
         6fyTHATB4JD/Kmiqwd0Nmd6z1tCHDJRWzzMQp0GuijMfccgPNirmi+zwHM7WABWiaQt+
         aAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=46aBPLkIQvF4Zc2qaB+8IQ8PDaV7KU+uxNNMa3ojlI8=;
        b=CSYPp/UU3T+cPPijKERvUR/nhSztzL+ghPnMNX7TKQeo3Ls8r97bNtjI8R8IsbZ8HS
         9gdaA9owTkEZ3WWtSxuWbMjFKso2eQOq3J/dCxSDbiqJ5PjBfywN3PqDzKRtzPW94lXm
         K0KUlxjuVhRICsWsfc+EeGyfHsfNi9J9uoml3WG6LAtIehS9wxz0rNX++nS2VlHg8piT
         bCueHxvku1b0XJjANC9gmIP+lK0UxL/Jnrt8lXqPML3iJNtWCTG9akgTNtbnKWjYAFu5
         5C+WggQL3+coaQLimJYytnFSjdg1M7eBcE38WDA2llViIU2VRP2uggPsxRJchJxZh2tx
         uNvQ==
X-Gm-Message-State: ACgBeo2bmkuNLr4HK7XlnzCbwg3GPvUJd4lDHOPzAehkNvKUr/DzhUex
        QtH4hI1dhXKAEwnEs4ESRXBzuQ==
X-Google-Smtp-Source: AA6agR4LXSQM5sF4Q8J4n+QZmHjK9xRIjiHn2gX+naQCy9Yl3E9nvZXNM0RW0pjRgmX9WNXvbnqX3Q==
X-Received: by 2002:a17:902:e751:b0:174:89f8:cef2 with SMTP id p17-20020a170902e75100b0017489f8cef2mr27415963plf.156.1662120698525;
        Fri, 02 Sep 2022 05:11:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a23-20020a1709027d9700b00174923afa8asm1468993plm.3.2022.09.02.05.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 05:11:37 -0700 (PDT)
Message-ID: <7b4f2fe5-9277-dacb-547c-00ae295a38cc@kernel.dk>
Date:   Fri, 2 Sep 2022 06:11:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1662116617.git.asml.silence@gmail.com>
 <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
 <c4958f35-11e5-5dd9-83c5-609d8b16801b@gnuweeb.org>
 <6fedd5a1-1353-9e71-6b3e-478810b5fc8a@kernel.dk>
 <cebbf0d4-2fba-71cc-16a1-b95d7b31d646@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cebbf0d4-2fba-71cc-16a1-b95d7b31d646@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 6:07 AM, Pavel Begunkov wrote:
> On 9/2/22 13:03, Jens Axboe wrote:
>> On 9/2/22 6:01 AM, Ammar Faizi wrote:
>>> On 9/2/22 6:56 PM, Ammar Faizi wrote:
>>>> On 9/2/22 6:12 PM, Pavel Begunkov wrote:
>>>>> Fix up helpers and tests to match API changes and also add some more tests.
>>>>>
>>>>> Pavel Begunkov (4):
>>>>> ??? tests: verify that send addr is copied when async
>>>>> ??? zc: adjust sendzc to the simpler uapi
>>>>> ??? test: test iowq zc sends
>>>>> ??? examples: adjust zc bench to the new uapi
>>>>
>>>> Hi Pavel,
>>>>
>>>> Patch #2 and #3 are broken, but after applying patch #4, everything builds
>>>> just fine. Please resend and avoid breakage in the middle.
>>>>
>>>> Thanks!
>>>
>>> Nevermind. It's already upstream now.
>>
>> Ah shoot, how did I miss that... That's annoying.
> 
> We can squash them into a single commit if we care about it.
> Don't really want do the disable + fix +e nable dancing here.

It's already pushed out, so whatever is there is set in stone... Not a
huge deal, but would've been nice to avoid. It's problematic when
someone needs to bisect and issue and runs into a non-compiling step.
Makes that process a lot more annoying, so yes we definitely do care
about not introducing build breakage in a series of patches.

-- 
Jens Axboe
