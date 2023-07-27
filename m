Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE84765353
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 14:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjG0MKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjG0MKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 08:10:12 -0400
Received: from out-79.mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEB72D64
        for <io-uring@vger.kernel.org>; Thu, 27 Jul 2023 05:09:59 -0700 (PDT)
Message-ID: <e8567efc-41e8-34bc-3f15-8ccab18fe5e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690459797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2IiMrVnPm2GksDnQaRoClODULldhxBaz6xJ84+JZngI=;
        b=Tn15TX75o4Z35uGZc50zKSZ6zbmWTsDCxMKTaC8yeMo6F5zkbjmAIGuRXevTTI/yTtSMxp
        U5u5gH+mOv/5983m1nmye0u+mcBdBzkO017JBMLXY3kt64sPuGFLE+tqlGHp5lKUb1j+0h
        r5uTfR/qjeVImGVsKcs40hOKt7kG1hM=
Date:   Thu, 27 Jul 2023 20:09:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 5/5] disable fixed file for io_uring getdents for now
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-6-hao.xu@linux.dev>
 <20230726-inhaftiert-hinunter-714e140c957c@brauner>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230726-inhaftiert-hinunter-714e140c957c@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/23 22:23, Christian Brauner wrote:
> On Tue, Jul 18, 2023 at 09:21:12PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Fixed file for io_uring getdents can trigger race problem. Users can
>> register a file to be fixed file in io_uring and then remove other
>> reference so that there are only fixed file reference of that file.
>> And then they can issue concurrent async getdents requests or both
>> async and sync getdents requests without holding the f_pos_lock
>> since there is a f_count == 1 optimization.
> 
> Afaict, that limitation isn't necessary. This version ow works fine with
> fixed files.
> 
> Based on the commit message there seems to be a misunderstanding.
> Your previous version of the patchset copied the f_count optimization
> into io_uring's locking which would've caused the race I described
> in the other thread.
> 
> There regular system call interface was always safe because as long as
> the original fd is kept the file count will be greater than 1 and both
> the fixed file and regular system call interface will acquire the lock.
> 
> So fixed file's not being usable was entirely causes by copying the
> f_count optimization into io_uring. Since this patchset now doesn't use
> that optimization and unconditionally locks things are fine. (And even
> if, the point is now moot anyway since we dropped that optimization from
> the regular system call path anyway because of another issue.)

I see, forgot we already remove it from fdtable after close(fd) thus
cannot access it by fd any more. I'll fix it in next version. Thanks.

Regards,
Hao
