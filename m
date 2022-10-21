Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B99607704
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 14:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiJUMig (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 08:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJUMiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 08:38:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006B626640D
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 05:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=MtkEfpOZINDsNaDhmVP6ouI8D1C+b9GGvWK9EYZaAtQ=; b=OIazEnxk1Vs8k/2ybxqdpSqyHr
        nW1zW2Eyro93/hwoZhsKtEdu5Apxot2apsuPrzgKN5//uCqlN6KUeEol3istEUK7W638VWysuMXQ1
        So5INSE0Lgw+p4QtQF2hHk3Of1+UO+t4KQ/UQ/VofIEZZxgNifaHNNvfgVju1EW7HMwVijrnk2fL5
        9MzfJSQX20jtxmr/t6zTwzPasnka577dikVZ+kNYE4y8WgBCG1EbWP9V764chsbYMXKU0GSSZ4onK
        sobC5TQWb0Ikha91bzrrM5RvLeZCmhTFHs1rWk5FhwI7Fdr9CvfcMHg1Gj0OWpdVgmCKOoegn6JAr
        VXDvmTtHx2hQV1hAW/l2BD7nrqhl7y0Sd9UazwH/lAppRNxw6M6mZQoUIjqJOWzWox880/wNPQzQA
        97u9QSa4N7sLc1sKHxn5yP2yUWT3GQrG+Jsfoa+n7dk+deKe5KvCZoBuewSTYxvM2mr1SkfCWtm7v
        Scz5FB8a5HKwQFt/7dWjp5xC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olrHr-0059o0-Rt; Fri, 21 Oct 2022 12:38:07 +0000
Message-ID: <954ab33b-4998-ca2b-79b2-d4b4ae9654b5@samba.org>
Date:   Fri, 21 Oct 2022 14:38:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
 <7b82ab4e-8612-02dc-865d-b5333e7ad534@samba.org>
 <585dfb72-1bcc-d562-68b5-48d1bacd3cac@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <585dfb72-1bcc-d562-68b5-48d1bacd3cac@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 21.10.22 um 13:26 schrieb Pavel Begunkov:
> On 10/21/22 11:15, Stefan Metzmacher wrote:
>> Hi Pavel, and others...
>>
>>>> As far as I can see io_send_zc_prep has this:
>>>>
>>>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>>                  return -EINVAL;
>>>>
>>>> both are u64...
>>>
>>> Hah, true, completely forgot about that one
>>
>> BTW: any comment on my "[RFC PATCH 0/8] cleanup struct io_uring_sqe layout"
>> thread, that would make it much easier to figure out which fields are used..., see
>> https://lore.kernel.org/io-uring/cover.1660291547.git.metze@samba.org/#r
> 
> I admit the sqe layout is messy as there is no good separation b/w
> common vs opcode specific fields, but it's not like the new layout
> makes it much simpler.

Really?

> E.g. looking who is using a field will get more complicated.

Why should anyone care what fields other opcodes use
and how they are named.

For legacy reasons we have to live with
struct io_uring_sqe_common common; in the middle.
apart from that each opcode should be free to use
5 u64 fields and 1 u32 field.

But e.g.

+               /* IORING_OP_FALLOCATE */
+               struct io_uring_sqe_fallocate {
+                       struct io_uring_sqe_hdr hdr;
+
+                       __u64   offset;
+                       __u64   length;
+                       __u32   mode;
+                       __u32   u32_ofs28;
+
+                       struct io_uring_sqe_common common;
+
+                       __u32   u32_ofs44;
+                       __u64   u64_ofs48;
+                       __u64   u64_ofs56;
+               } fallocate;

Immediately shows what's used and what not
and it avoids brain dead things like using
sqe->addr instead of sqe->len for the length.

And it makes it trivial to verify that the _prep function
rejects any unused field.

And it would it easier to write per opcode tracing code,
which can be easily analyzed.

> iow, no strong opinion on it.
> 
> btw, will be happy to have the include guard patch from one of
> your branches

This one from the io_uring_livepatch.v6.1 branch?
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=3c36e05baad737f5cb896fdc9fc53dc1b74d2499

metze


