Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4327A75BAB8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjGTWiX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjGTWiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:38:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D25171A;
        Thu, 20 Jul 2023 15:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689892699; x=1690497499; i=deller@gmx.de;
 bh=AN6gciVKJbgTTKjF9HKj4d1ijZnIjwfv5oKJ6jaykDw=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=bpPeUeSQjyOXlr4SspzpArxkg9uG8xxwNPGRk39Hsz/kyi71oCLNI6/J9jX/h3vO45WCPq+
 au6OpahEvkbKCvEdVS5MXIACgERAnm54QpIKQi2gvtBjVxk8vHGdAyhCsOiMzW1r9kfjRfZaa
 YLZl4ffv78Yb6WX+KnfKtMWhOkqQaScFh4WSHpvqU6aeR/QmIEWXLGGvWoNl+M3bjQVgFIm3S
 xPZzQBr66m5nukNUqJF8mO81qtKqzA3a8NPrKmi+gw2KnJRIn1zXgAZoiTg39lXapJg/tEdkl
 erHMCSkWWrzcLpRq4fzry7ae87yhstmCZ4OP8DIsQydNkx7Xqmrw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.153.9]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MS3mz-1qTWxl3QXT-00TVpT; Fri, 21
 Jul 2023 00:38:18 +0200
Message-ID: <be208704-b312-f04d-4548-90853a638752@gmx.de>
Date:   Fri, 21 Jul 2023 00:38:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        linux-parisc@vger.kernel.org
References: <ZLhTuTPecx2fGuH1@p100>
 <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bDlWMGHtU8u6mzCoVhH+JpOGf3DzdzL2Lm+SphqpfvLkd5x9S/5
 y0inFWNx6GgaPk0yp659NA6MXvgLa50c/szcT8tE5mCiPjvDBALp4iLEIYoMWb0jFmZb3Q9
 JQADeBhnZH9TOkM5PoTuzK5W1y7H8tfZHQrhPcRBbAc/ZcaOG3e2XRq2JoD/QwwicFvShbx
 VSC/WETZNHog4ApFdRAmg==
UI-OutboundReport: notjunk:1;M01:P0:IsYozpIzT0w=;PuPL2hzjpDuNJGaoqAqv5QvY1pS
 Az3uW9T3CFsXXGZDOY+j+nTm/Fl6ev9hH3B5UOGi6DslpEkyzH39c12BwI/W7UMBOkN6ZfL+c
 r9GH2aKCathWnzMpVUYnJMLJ/YyqsoVcC80dtRabjccFB5TCKzO8wdFcOnAHEFsE49wHDZu4c
 nHYA0OS5u1PU/OmIjxcH6svYkKt6TYt2vxlnU2cG0GOIO05vUtmN2d+URcy63Awl78k3Lpcv/
 CTQXzYXAGZQ2+XvnqqhNVzS19ZlfXQzd9kjtjQ8OaEQLEqhgfUCzDNTdefMkf1xOPy4ihY8e9
 wrAFxARZGyZ/MzPq654zHnOEp6vF7BZoLn07DF6JZ7tduQth6V2wG4x0jIgItPvq5+eYirSHI
 S6hHPfqUja/vm3Jdy4pDxeBpfH2N2QCfvhjRY82wu/xqjL72dVNYGAUmGhkrHj7DL2ZdGRhIY
 pWyk/ckOFQtF92w5UR78vWJYooyNBVoQamHfsgZBtONjtm+nohjB54Da/N74WNw1uCdbJyN/O
 VENua/5UNEBCADXRrBFQtzPnbHAvWY5xq0E8M8ZyKsmQDC1WDaq8vCYbXQY7Ri8H0ovsXghGt
 s2mnx46XvJ9RpcTfK837GWZUJlAeVt1RJoK12/H/0kx0N8boRO6B4lMvkd0CV6MU1PT7HDwiB
 HF7AcR/KQOK49PqmsZkVlIH6d6OmwjBVmQGgmpZMuKRUOCBcGCcBU2umUqWTlB/C4j4Wthr2p
 sUKiDDBqpLJkCl5/WXRVGrDnVDtRTMQnQKeNma0SCukGY34SvaB/T5B6UHaZsyhe2kswGUqdV
 fqrDB/qouINissydUtcJz/Yejs9OxMfk5+Mvlt9oK9cdJkdHqoAKAH+JZ5ZRVGY4a8plDZTxs
 9A5iRcrkYqKq+twhju1exmE75Soc1N13v3aw+fQjAkWR5HU/DDz7SC2uHtxKmStErgkKsk5ZC
 jUCZZjWGTnHw3cBsxX7nzR3Ig/E=
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 00:30, Jens Axboe wrote:
> On 7/19/23 3:20?PM, Helge Deller wrote:
>> The io_uring testcase is broken on IA-64 since commit d808459b2e31
>> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
>>
>> The reason is, that this commit introduced an own architecture
>> independend get_unmapped_area() search algorithm which doesn't suite th=
e
>> memory region requirements for IA-64.
>>
>> To avoid similar problems in the future it's better to switch back to
>> the architecture-provided get_unmapped_area() function and adjust the
>> needed input parameters before the call.  Additionally
>> io_uring_mmu_get_unmapped_area() will now become easier to understand
>> and maintain.
>>
>> This patch has been tested on physical IA-64 and PA-RISC machines,
>> without any failures in the io_uring testcases. On PA-RISC the
>> LTP mmmap testcases did not report any regressions either.
>>
>> I don't expect issues for other architectures, but it would be nice if
>> this patch could be tested on other machines too.
>
> Any comments from the IA64 folks?

matoro tested it on ia64 at least...

> Helge, should this be split into three patches? One for hppa, one for
> ia64, and then the io_uring one?

If we split up, I would prefer to split it into 2 patches:
One for io_uring together with the hppa patch, since they should go in tog=
ether.

The ia64 patch is probably unrelated, and can go seperately. But
there doesn't seem to be any ia64 maintainer...?

Do you have a chance to test this patch on the other io_uring platforms,
without applying it into your tree? I think some testing would be good.

Helge
