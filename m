Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552264B2AED
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 17:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351722AbiBKQtK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 11:49:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiBKQtK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 11:49:10 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ED58D
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:49:08 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id d7so1513846ilf.8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=vIBIHUimb+HRegwLDKQ0U9L7SNNKPECNW0fNH2Byc/A=;
        b=3I5uv8vViwuAUTBdnaz7NMtUTskstrgQGcZyVYjPeeq/uGKG9DjJIS8vjFG1xvyrmx
         hr15xPO/F0iDlzH0UpXdxRvWdOSkd4LU7e7Z/+TdeVy4kAujvN3olHx0uq0DIWmzhAST
         dV+Lpy3jO0fO0vYp9icWzEU7UVuiKnbQ1sY7uqDGo6/dyNDjr7KZRotyLlcH9bEbaW+/
         wbk5HGhwz3MZXrzjZntRXuIQ8M0sf7SwqrcFCU3LScUCNiGh+9Tm1IiLnN/8JkRvLcz+
         k5Zs7CAOIhKYUVhFTM6AsrGo/Ca+lq7jQZO3xeEqOAcx/TEVMj7G0nDvij88bQv1S6Si
         vUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=vIBIHUimb+HRegwLDKQ0U9L7SNNKPECNW0fNH2Byc/A=;
        b=X4qZvomrCXeg3GbM2V1vWogjIX+FQ4s/McH80VT4ub3Pl86fpXi3dmFt0w9Qv2oLuw
         Fulg4K/+ZI4NJAyuWEklfQpnfDIpqHExoM/i1/o/tNzn7/hsQja2fbhEgiUoGJmTnWGU
         E2GMYdPwrHxZcbeWna6kYdkiHMx00Lxe+bofJZ0qVFuHCcrLyD9HoAbcIpKt2LZc6RrU
         CEwOa4qcbXVf1Cr0+/T4FvBxdqfvn5LiNy1NqxlxOBuilVsMhrbE82TkZWxSrcdwXtPP
         U5pVRLlXcmhWtETjbxpTBYSd+5fzH+c2fnrSEtd0OCcSmeNFfrgbarDxNdKMeGsD449o
         HkeA==
X-Gm-Message-State: AOAM533NdPMwa0O3Vu1aPts6IGQUrxeZY8NF00KYsPqhUpgR4qxN7CYd
        9absX07M57LOKgLRvgtdT9m4/ambKBAL2NjW
X-Google-Smtp-Source: ABdhPJymTd1CcJVTswvNUGPRiP7S+6pnrfrZaeU2+BIgR9vtssukCNheI6JOp1+va1RSfE7L520s0g==
X-Received: by 2002:a92:ca4d:: with SMTP id q13mr1266511ilo.165.1644598147724;
        Fri, 11 Feb 2022 08:49:07 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r9sm13942145ill.52.2022.02.11.08.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:49:07 -0800 (PST)
Message-ID: <bdc1cfce-e78b-bf75-de0a-77e13116e710@kernel.dk>
Date:   Fri, 11 Feb 2022 09:49:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.17-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

- Fix a false-positive warning from an older gcc (Alviro)

- Allow oom killer invocations from io_uring_setup (Shakeel)

Please pull!


The following changes since commit f6133fbd373811066c8441737e65f384c8f31974:

   io_uring: remove unused argument from io_rsrc_node_alloc (2022-01-27 
10:18:53 -0700)

are available in the Git repository at:

   git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-11

for you to fetch changes up to 0a3f1e0beacf6cc8ae5f846b0641c1df476e83d6:

   mm: io_uring: allow oom-killer from io_uring_setup (2022-02-07 
08:44:01 -0700)

----------------------------------------------------------------
io_uring-5.17-2022-02-11

----------------------------------------------------------------
Alviro Iskandar Setiawan (1):
       io_uring: Clean up a false-positive warning from GCC 9.3.0

Shakeel Butt (1):
       mm: io_uring: allow oom-killer from io_uring_setup

  fs/io_uring.c | 8 +++-----
  1 file changed, 3 insertions(+), 5 deletions(-)


-- 
Jens Axboe

