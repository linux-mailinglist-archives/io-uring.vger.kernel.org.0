Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8484D76A5BE
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 02:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjHAAtu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 20:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjHAAtt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 20:49:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE04EE
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 17:49:48 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so711593a12.0
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 17:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690850988; x=1691455788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=koxbdmEJ5MsPm0n7uh5wB/ALoxfyANpPgwtgNgqGsj8=;
        b=5hHTJGsdcMjqEMnSYQMRQ0rbRs4unt+O/+S5TEc2Yn9Ia8XgKrcrcvn+87Btfx8QYb
         SUL/cKiVq5KvArVZWtqy/mZ7rNUrtUU6CTO+V9FW5x8WbgooksbuT2T2MOlohsY+Ui5O
         o+c8/ar5B/mHbQjbkIEJxUeCqOEtEBhEb7gz4jmmyahMRMbFJ1Rr4Yy5lghK+cCDChBh
         Yj9RpQMfJJC5Q9i5KGJ/GDm7VbvHPHJ2s7DAZA/wzaKiVJ+kOju8CBYXeSJSWN1GYLbG
         3mVLo2rpdho6RHOjUNVJvQuRrhioExzW2vCxguCD7Po96LIplij6DR2K4Unppz3e1Mv6
         H+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690850988; x=1691455788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=koxbdmEJ5MsPm0n7uh5wB/ALoxfyANpPgwtgNgqGsj8=;
        b=QSbWfme8OYHZyaN8ak41hZTi4H+my+NmH3tmOqUd/Dev1vyPBXi41qoQVsWZ4WEKI/
         uRS73JWbPFYf0fTGZBFShhvEQO1zp9QI+0tRba+GsvHb9wOBDf1+0UgCx5uxkiKIjFYU
         zuBeKPxSy56hqvfDoVF6ADsXZbnQFloMeUAokHq5nHFzKang0HCjkVKVMv0BjbTCNY1T
         fX13zijthnJFD0XMScSBm+RiTZ2Wcm68fx8F64IoOVOg6e5rnJMLP2DBUuTLzf4XM7JJ
         AYyLa3LpxosEuOZej2GcHX/0eLgGn797Gyl8KUU/+MYBSJ/7h6wUO4bA5P72LYMiFLrm
         0PYw==
X-Gm-Message-State: ABy/qLbC6Sf97+ZDiamhFcIaYYKk6yZBpTIjp7K9t8F8iJ/OkxAUHLzA
        4Wqas+G0jT4jMqmbPnP5A3FAQyeUFV9OB/8PrO8=
X-Google-Smtp-Source: APBJJlHTpftWznOHsEDgQ4Wdpw3cGJZ/nXtjnyz5Fg/39BpPzWuYaxrYHM9M47aeAHb+RajawND4bA==
X-Received: by 2002:a17:90a:e42:b0:268:4dd4:a991 with SMTP id p2-20020a17090a0e4200b002684dd4a991mr7557434pja.1.1690850987804;
        Mon, 31 Jul 2023 17:49:47 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ce9000b001b5656b0bf9sm9113348plg.286.2023.07.31.17.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 17:49:47 -0700 (PDT)
Message-ID: <e2d8e5f1-f794-38eb-cecf-ed30c571206b@kernel.dk>
Date:   Mon, 31 Jul 2023 18:49:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
 <ZMhWI/2UIFAb3vR7@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZMhWI/2UIFAb3vR7@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 6:47?PM, Matthew Wilcox wrote:
> On Mon, Jul 31, 2023 at 06:28:02PM -0600, Jens Axboe wrote:
>> It's also not an absolute thing, like memory allocations are. It's
>> perfectly fine to grab a mutex under NOWAIT issue. What you should not
>> do is grab a mutex that someone else can grab while waiting on IO. This
>> kind of extra context is only available in the code in question, not
>> generically for eg mutex locking.
> 
> Is that information documented somewhere?  I didn't know that was the
> rule, and I wouldn't be surprised if that's news to several of the other
> people on this thread.

I've mentioned it in various threads, but would probably be good to
write down somewhere if that actually makes more people see it. I'm
dubious, but since it applies to NOWAIT in general, would be a good
thing to do regardless. And then at least I could point to that rather
than have to write up a long description every time.

-- 
Jens Axboe

