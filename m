Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED86040B09F
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhINObF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhINObF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:31:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC374C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:29:47 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id b15so13768426ils.10
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AeKPdJkON/OS1xRzJpMlUL/n5nR6lAT2cMyuevciU6s=;
        b=sgnVoWBN05D50YFFgMl+IvYWHkwoYAesBKkRNAScsyxkLUzkYvSikrTp8Fz67UCZtR
         uuIX3Ex9PTZkhzRjQ0/7vFqN6t5uOFtId2oRbwbdpNQwhvisJHwEt7H9YESFmL4d4PM+
         H1UIe2f27ZaDuFqSZIWSA2ZRxaL9bM8LezZcbXvjBSm5W42OX79nOgD+fE5SoA0lg81k
         /feidncll2VN09pFzsVyz7aNRyaAvAl2sEsh9G7YRbpC1K3tmXQ6dk3XXQ7W7Q3HJHqU
         RBim+Xy+yCuDlSCBxVgtU0Y00Y1LptDGJzmluWj0dwMBFmQaRClzTeFFxWCHQR72H4dv
         OQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AeKPdJkON/OS1xRzJpMlUL/n5nR6lAT2cMyuevciU6s=;
        b=08L/j7ny9+rPhNomOwmqTjKzem0OIvvElLvJJ/Wkelv7i41CH5/UaZBTKTqtrie6ZE
         hjiMMbBog76L9FjtpTfL9n9s+p/Tf1mZL7fWI4grHH6yUNONp2qjnD/GVHxST6rItJr6
         KT4fJ6J15geRi+8A5HFvmlnxL5cA7xrbqdqZD7Voi0jL4QrLZsyMr1DhiNjPPIWVDFgw
         S76UMB6m3l0SsUXbOTHeen7AWJrDq3CXO5WtPb0WV8IgTUIntLEE5Gs/kaJS6K9Qlf2P
         3PKKsnO5EkZ1IYO5P14wvnlFyROjNC+SQooot3YEeHobn6Z2yU/RguKybFXisNZVMtL2
         oQhg==
X-Gm-Message-State: AOAM5331oeIIwSxF+v1w9BQODyc3ujnsqj7Vd6CMrgP8Z6otawEgjPbf
        hGbvCP97cWmG5eDwU8jgrjW2Z5lOrTDc5uE329o=
X-Google-Smtp-Source: ABdhPJz+eXv1oobhVUf9fX7i2z+ZhvTPYuPGLpQouJXB/hhfW3x1+lGU4ugYRQ8egYlOWRAGt6dgVw==
X-Received: by 2002:a05:6e02:1747:: with SMTP id y7mr12627605ill.5.1631629787233;
        Tue, 14 Sep 2021 07:29:47 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d10sm7170505ilu.54.2021.09.14.07.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:29:46 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add missing sigmask restore in io_cqring_wait()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210914084139.8827-1-xiaoguang.wang@linux.alibaba.com>
 <45cb9bb5-3132-6873-a423-d037e6db01a5@kernel.dk>
 <f0c26fd2-667f-8f94-446d-4da064a712d9@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6fe24a51-4d66-de57-add6-42cb5e980886@kernel.dk>
Date:   Tue, 14 Sep 2021 08:29:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f0c26fd2-667f-8f94-446d-4da064a712d9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 8:28 AM, Xiaoguang Wang wrote:
> hi,
> 
> 
>> On 9/14/21 2:41 AM, Xiaoguang Wang wrote:
>>> Found this by learning codes.
>> Does look like a real bug. But how about we move the get_timespec() section
>> before the sigmask saving?
> 
> Ok,  I thought about this method before :)

When you send a v2 with that, please do also write a proper commit message.
It should explain why the change is needed. Thanks!

-- 
Jens Axboe

