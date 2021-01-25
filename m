Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE0302404
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 12:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbhAYLBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 06:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbhAYLAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 06:00:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CA4C0613D6
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 02:52:39 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id s24so10233242wmj.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 02:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Keb9SfsqWwTLYpQW6mR6czDywnZWrj2KiX8N5HK2Kk=;
        b=QA/sztie/aAcqofY9mCplcBjLfPCb1xQzb7rpygSYBjzwHeOXNXX5g4n7UcSxTLFcf
         jfNSWEvOBqbep0+keyEwjv0RJmYUjjwgqARLxkMBXbqINa4WgNhc62jNxCT9e/Do1SB8
         uVQMhXX3ya+zaBBH10yao7IyY9dTX/E5TSYzUJzENvYJmaH3VmL2mRrxSpLIOnM9C7XF
         72AD8aDdiwxYCrkaKMzwH9Cs2abJ8lBQ9sFjCbMcCS5KZLCtnw4RMVauNHRQgV045Luc
         NLP0JVl6lYKvb6p75t9wiZQbf+SeD5+BSfol9Z37fzdTAuc64ch3ENTC1LUUzEOBOU6h
         j+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Keb9SfsqWwTLYpQW6mR6czDywnZWrj2KiX8N5HK2Kk=;
        b=JUM972mZikogaCZOP3R1F9GeuROE4lEiRNDu8CA8iadAomQ1EyjVMiu7wS+guFPMHQ
         FxDKBcQamT5PVYcRZVpICnKpO+UGvhcE/rNhFajYIPgun82igQVATdtrRKyrOaQKzJep
         adaHcqcJ7Uq7iGIJuaMlXZMLTDiFbWP493Za4ypS3cJ052OA+O+4Cin6OGnd194FnIfX
         LsR15U7EoDky+0eddQKbuAMR541w6kuNI+vA0lwQ0WVuqsIOlXcyv5hecbnog+pUXR7+
         GxeCp6+NlFLqZjWtthYTsnViuFEJ+4wLlrHELeoQCsEubezlM+9bIloUe7bg4RUsKn/1
         K4+A==
X-Gm-Message-State: AOAM532L/4lFsQa2fSD9p2WaFsXX5ChLgS6W7smkeyA9ohq9fWujtZdJ
        pg7qvkJSLEQuoIHkTOR1J8s8FjgICcw=
X-Google-Smtp-Source: ABdhPJxncGVWqCob8Ed9UDIANZrILR5/0VnV9qFZ9aQhG67GYf4d/rNnXQjt6XlYL/5IgiS+/P1ECg==
X-Received: by 2002:a1c:b0c2:: with SMTP id z185mr1174431wme.111.1611571958124;
        Mon, 25 Jan 2021 02:52:38 -0800 (PST)
Received: from [192.168.8.152] ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id v22sm19902021wml.2.2021.01.25.02.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 02:52:37 -0800 (PST)
To:     Joseph Qi <jiangqi903@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1611109718.git.asml.silence@gmail.com>
 <246d838d-0fce-d3c3-dcfc-9cbf9fa72de1@gmail.com>
 <55e5491c-73c3-8d13-e3d1-056a2506f285@gmail.com>
 <4ddd9aa4-bbdd-9730-f1b9-7a26ccaaf842@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/3] files cancellation cleanup
Message-ID: <09aec3c5-bf2a-92cd-4388-2403ba9f4bd3@gmail.com>
Date:   Mon, 25 Jan 2021 10:48:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4ddd9aa4-bbdd-9730-f1b9-7a26ccaaf842@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/01/2021 02:14, Joseph Qi wrote:
> On 1/23/21 5:49 AM, Pavel Begunkov wrote:
>> On 22/01/2021 09:45, Joseph Qi wrote:
>>> Seems this series can also resolve a possible deadlock case I'm looking
>>> into.
>>
>> It removes dead code, I believe your issue is solved by
>> ("io_uring: get rid of intermediate IORING_OP_CLOSE stage")
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.12/io_uring&id=7be8ba3b656cb4e0158b2c859b949f34a96aa94f
>>
> I've tested the above commit and the mentioned possible deadlock still
> exists.

I pasted a wrong patch, apparently had something else on my mind...
The intention was to point to a Jens' patch that made mentioned in
your report __io_uring_files_cancel() unreachable, though it was
dropped for unrelated reasons. So... the bug is still here at the
moment.

Anyway, thanks a lot for testing! Your reports are very helpful

>> Did you try this series in particular, or tested for-5.12/io_uring
>> and see that the issue is gone there?
>>
> I don't have this tree locally and it takes too long to clone it down.
> Will check once it is ready.
> 
> Thanks,
> Joseph
> 
>>> CPU0:
>>> ...
>>> io_kill_linked_timeout  // &ctx->completion_lock
>>> io_commit_cqring
>>> __io_queue_deferred
>>> __io_queue_async_work
>>> io_wq_enqueue
>>> io_wqe_enqueue  // &wqe->lock
>>>
>>> CPU1:
>>> ...
>>> __io_uring_files_cancel
>>> io_wq_cancel_cb
>>> io_wqe_cancel_pending_work  // &wqe->lock
>>> io_cancel_task_cb  // &ctx->completion_lock
>>>

-- 
Pavel Begunkov
